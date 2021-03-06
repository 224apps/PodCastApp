//
//  PodcastFeedLoader.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/15/21.
//

import Foundation
import FeedKit


class PodcastFeedLoader {
    
    func fetch(lookupInfo: PodcastLookupInfo, completion: @escaping (Result<Podcast, PodcastLoadingError>) -> Void) {
        let req = URLRequest(url:lookupInfo.feedURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.loadError(error)))
                }
                return
            }
            
            let http = response as! HTTPURLResponse
            switch http.statusCode {
                case 200:
                    if let data = data {
                        self.loadFeed(lookupInfo: lookupInfo, data: data, completion: completion)
                    }
                    
                case 404:
                    DispatchQueue.main.async {
                        completion(.failure(.notFound))
                    }
                    
                default:
                    DispatchQueue.main.async {
                        completion(.failure(.requestFailed(http.statusCode)))
                    }
            }
        }.resume()
    }
    
    func loadFeed(lookupInfo: PodcastLookupInfo, data: Data, completion: @escaping (Result<Podcast, PodcastLoadingError>) -> Void) {
        let parser = FeedParser(data: data)
        parser.parseAsync { parseResult in
            let result: Result<Podcast, PodcastLoadingError>
            do {
                switch parseResult {
                    case .success(let feed):
                        switch feed {
                            case .atom(let atom):
                                result = try .success(self.convert(atom: atom, lookupInfo: lookupInfo))
                            case .rss(let rss):
                                result = try .success(self.convert(rss: rss,lookupInfo: lookupInfo))
                            case .json(_): fatalError()
                        }
                    case .failure(let e):
                        result = .failure(.feedParsingError(e))
                }
            }catch let e as PodcastLoadingError {
                result = .failure(e)
            } catch {
                fatalError()
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    private func convert(atom: AtomFeed, lookupInfo: PodcastLookupInfo) throws -> Podcast {
        guard let name = atom.title else { throw PodcastLoadingError.feedMissingData("title")  }
        
        let author = atom.authors?.compactMap({ $0.name }).joined(separator: ", ") ?? ""
        
        guard let logoURL = atom.logo.flatMap(URL.init) else {
            throw PodcastLoadingError.feedMissingData("logo")
        }
        
        let description = atom.subtitle?.value ?? ""
        
        let p = Podcast(id: lookupInfo.id, feedURL: lookupInfo.feedURL)
        p.title = name
        p.author = author
        p.artworkURL = logoURL
        p.description = description
        p.primaryGenre = atom.categories?.first?.attributes?.label
        p.episodes = (atom.entries ?? []).map{ (entry)  in
            let episode = Episode()
            episode.identifier = entry.id
            episode.title = entry.title
            episode.description = entry.summary?.value
            episode.enclosureURL = entry.content?.value.flatMap(URL.init)
            return episode
        }
        return p
    }
    
    private func convert(rss: RSSFeed, lookupInfo: PodcastLookupInfo) throws -> Podcast {
        guard let title = rss.title else { throw PodcastLoadingError.feedMissingData("title") }
        guard let author = rss.iTunes?.iTunesAuthor ?? rss.iTunes?.iTunesOwner?.name else {
            throw PodcastLoadingError.feedMissingData("itunes:author, itunes:owner name")
        }
        let description = rss.description ?? ""
        guard let logoURL = rss.iTunes?.iTunesImage?.attributes?.href.flatMap(URL.init) else {
            throw PodcastLoadingError.feedMissingData("itunes:image url")
        }
        
        let p = Podcast(id: lookupInfo.id, feedURL: lookupInfo.feedURL)
        p.title = title
        p.author = author
        p.artworkURL = logoURL
        p.description = description
        p.primaryGenre = rss.categories?.first?.value ?? rss.iTunes?.iTunesCategories?.first?.attributes?.text
        p.episodes = (rss.items ?? []).map{ item in
            let episode = Episode()
            episode.identifier = item.guid?.value
            episode.title =  item.title
            episode.description = item.description
            episode.publicationDate = item.pubDate
            episode.duration  = item.iTunes?.iTunesDuration
            episode.enclosureURL = item.enclosure?.attributes?.url.flatMap(URL.init)
            
            return episode
        }
        return p
    }
}
