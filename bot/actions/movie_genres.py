from rasa_core_sdk import Action
from rasa_core_sdk.events import SlotSet
from concurrent.futures import TimeoutError
import requests
import random
import os

API_KEY = '7799cbd7e8e56452574a74d17f88c5dc'


class ActionGeneroFilmes(Action):
    def name(self):
        return "action_genero_filmes"

    def run(self, dispatcher, tracker, domain):
        response = {}
        try:
            dispatcher.utter_message('Tô tentando pegar as infos aqui!')
            response = requests.get(
                'https://api.themoviedb.org/3/genre/movie/list?api_key=7799cbd7e8e56452574a74d17f88c5dc&language=pt-BR',
                timeout=5
            ).json()
            genres = response['genres']

            message = 'Olha, eu conheço alguns gêneros de filme... Tem:\n'

            for genre in genres:
                message += '->' + genre['name'] + '\n'

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
