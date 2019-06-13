from rasa_core_sdk import Action
from rasa_core_sdk.events import SlotSet
from concurrent.futures import TimeoutError
import requests
import random

class ActionMovieRecommendation(Action):
    def name(self):
        return "action_recomendar_filmes"

    def run(self, dispatcher, tracker, domain):
        response = {}

        dispatcher.utter_message(
            'Bom... Tenho uma lista dos filmes populares do dia. '
            'São muitos filmes, mas vou te mandar só os primeiros aqui, '
            'com o título e a sinopse, pra você ter uma ideia:'
        )

        try:
            response = requests.get(
                'https://api.themoviedb.org/3/movie/popular?api_key=7799cbd7e8e56452574a74d17f88c5dc&language=pt-BR',
                timeout=5
            ).json()

            results = response['results']
            message = ''

            for result in results:
                message += 'Título:\n' + result['title'] + '\n'

                if (result['overview']):
                    message += 'Sinopse:\n' + result['overview'] + '\n\n'
                else:
                    message += '\n'

            print(message)

            dispatcher.utter_message(message)

        except TimeoutError as timeouterror:
            dispatcher.utter_message(
                'Minha internet não tá muito boa... Tentei pegar a lista '
                'mas não consegui :(\n'
                'Tenta daqui a pouco! Talvez dê certo ;)'
            )
            return []
        except Exception as exception:
            dispatcher.utter_message("Problemão!")
            dispatcher.utter_message(exception)
            return []

        return []
