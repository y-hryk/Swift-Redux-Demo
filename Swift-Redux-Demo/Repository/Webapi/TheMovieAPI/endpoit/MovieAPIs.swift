import Foundation

extension TheMoviebd {
    enum MovieAPIs {
        struct GetMovieTopRated: TheMoviebdAPIRequestProtocol {
            typealias ResponseType = MovieListResponse
            var method: HTTPMethod { .get }
            var path: String { "/movie/top_rated" }
            var parameters: [String : String]? {
                [
                    "language": NSLocale.localeString(),
                    "page": "\(page)"
                ]
            }
            var page: Int
        }
        
        struct GetMovieDetail: TheMoviebdAPIRequestProtocol {
            typealias ResponseType = MovieDetailResponse
            var method: HTTPMethod { .get }
            var path: String { "/movie/\(movieId)" }
            var parameters: [String : String]? {
                ["language": NSLocale.localeString()]
            }
            let movieId: String
        }
        
        struct GetImages: TheMoviebdAPIRequestProtocol {
            typealias ResponseType = MovieImageResponse
            var method: HTTPMethod { .get }
            var path: String { "/movie/\(movieId)/images" }
            var parameters: [String : String]? {
//                ["language": NSLocale.localeString()]
                nil
            }
            let movieId: String
        }
        
        struct GetCasts: TheMoviebdAPIRequestProtocol {
            typealias ResponseType = MovieCreditsResponse
            var method: HTTPMethod { .get }
            var path: String { "/movie/\(movieId)/credits" }
            var parameters: [String : String]? {
                ["language": NSLocale.localeString()]
            }
            let movieId: String
        }

        struct GetReviews: TheMoviebdAPIRequestProtocol {
            typealias ResponseType = ReviewListResponse
            var method: HTTPMethod { .get }
            var path: String { "/movie/\(movieId)/reviews" }
            var parameters: [String : String]? {
                nil
            }
            let movieId: String
        }
        
    }
}
