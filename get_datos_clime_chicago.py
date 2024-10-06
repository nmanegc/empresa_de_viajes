# Se cargan todas la librerías
import requests
import re
import pandas as pd
from bs4 import BeautifulSoup

# Se carga la URL de la página web con la inforamción requerida
URL = 'https://practicum-content.s3.us-west-1.amazonaws.com/data-analyst-eng/moved_chicago_weather_2017.html'

# Se extrae el texto de la página web y se almacena en la variable 'soup'
req_text = requests.get(URL)
soup = BeautifulSoup(req_text.text, 'lxml')

# Se extraen la información de interés de la página web, para ello se busca por el atributo attrs={"id": "weather_records"}, con la ayuda de 'BeautifulSoup'
records = soup.find('table', attrs={"id": "weather_records"})

# Se crea una lista para almacenar los nombres de las columnas
# Luego se busca por elementos 'th' dentro de la página web con la ayuda de un bloque 'for', y se agregan a la lista
heading_df = []
for row in records.find_all(
    'th'
):
    heading_df.append(
        row.text
    )

# Se crea una lista para almacenar los datos de la tabla
# Se busca por la información de las etiquetas 'tr'
data = []
for row in records.find_all('tr'):
    # Se excluye la etiqueta del encaezado, ignorando la etiqueta 'td'
    if not row.find_all('th'):
        data.append([element.text for element in row.find_all('td')])
        # Dentro de cada fila, el contenido de la celda está envuelto en etiquetas <td> </td>
        # Necesitamos recorrer todos los elementos <td>, extraer el contenido de las celdas y agregarlo a la lista
        # Luego agregamos cada una de las listas a la lista de contenido

# Se pasa la lista de 'data' como datos y 'heading_df' como encabezado
# para crear el DataFrame
weather_records = pd.DataFrame(data, columns=heading_df)
print(weather_records)
