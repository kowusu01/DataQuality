
import plotly.express as px
import pandas as pd
import numpy as np

df = pd.read_csv('who-countries.csv')
df["error-rate"] = 0
df.loc[df['who-region-code'] == 'AMR', 'error-rate'] = 10

df = df[df['who-region-code'] == 'AMR']
print(df.head())

fig = px.choropleth(df, locations="alpha-3-code",
                    color="error-rate", 
                    hover_name="who-region-code", # column to add to hover information
                    color_continuous_scale=px.colors.sequential.Plasma)
fig.show()