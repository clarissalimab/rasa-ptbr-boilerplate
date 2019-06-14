from rasa_core_sdk import Action
from rasa_core_sdk.events import SlotSet
import requests
import random

class ActionMovieRecommendationType(Action):
    def name(self):
        return "action_movie_recommendation_type"

    def run(self, dispatcher, tracker, domain):
        tipo = tracker.current_state()['latest_message']['entities'][0]['value']

        movie_all_types = self.movie_types()
        movie_types = [movie_type['name'] for movie_type in movie_all_types]

        movie_types = [movie.lower() for movie in movie_types]

        if movie_types == []:
            dispatcher.utter_message(
                'Tive um problema em pegar os tipos de filmes...'
                ' Tenta mais tarde!'
            )
        else:
            if tipo in movie_types:
                movie_id = [movie_type['id'] for movie_type in movie_all_types if movie_type['name'].lower() == tipo]
                movie_id = movie_id[0]
                movies = self.get_movies()
                filtered_movies = [movie['title'] for movie in movies if movie_id in movie['genre_ids']]

                message = 'Os primeiros filmes que eu consegui buscar foram:\n'
                for movie in filtered_movies:
                    message += '-> ' + movie + '\n'

                dispatcher.utter_message(message)
            else:
                dispatcher.utter_message(
                    'Foi mal, mas esse tipo de filme que você falou não consta'
                    ' na minha base de dados... Pode perguntar sobre outro?'
                )

        return []

    def movie_types(self):
        response = {}
        try:
            response = requests.get(
                'https://api.themoviedb.org/3/genre/movie/list?api_key=7799cbd7e8e56452574a74d17f88c5dc&language=pt-BR',
                timeout=5
            ).json()

        except TimeoutError as timeouterror:
            print(timeouterror)
            return []
        except Exception as exception:
            print(exception)
            return []

        return response['genres']

    def get_movies(self):
        response = {}

        response = requests.get(
            'https://api.themoviedb.org/3/movie/popular?api_key=7799cbd7e8e56452574a74d17f88c5dc&language=pt-BR',
            timeout=5
        ).json()

        results = response['results']

        return results
