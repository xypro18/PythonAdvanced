import click
import requests
import os
import re

def current_weather(location, api_key):
    url = 'http://samples.openweathermap.org/data/2.5/weather'

    query_params = {
        'q': location,
        'appid': api_key,
    }

    response = requests.get(url, params=query_params)
    
    return response.json()['weather'][0]['description']

class ApiKey(click.ParamType):
    name = 'api-key'

    def convert(self, value, param, ctx):
        found = re.match(r'[0-9a-f]{32}', value)

        if not found:
            self.fail(
                f'{value} is not a 32-character hexadecimal string',
                param,
                ctx,
            )

        return value

@click.group()
@click.option(
    '--api-key', '-a',
    type=ApiKey(),
    help='Your API key for the OpenWeatherMap API',
)
@click.option(
    '--config-file', '-c',
    type=click.Path(),
    default=f'{os.getcwd()}/settings.cfg',
)
@click.pass_context
def main(ctx, api_key, config_file):
    if not api_key and os.path.exists(config_file):
        with open(config_file) as cfg:
            api_key = cfg.read()

    ctx.obj = {
        'api_key': api_key,
        'config_file': config_file,
    }

@main.command()
@click.argument('location')
@click.pass_context
def current(ctx, location):
    """
    Show the current weather for a location using OpenWeatherMap data.
    """
    api_key = ctx.obj['api_key']
    
    if not api_key:
        click.secho('Missing API key. Run the config command or use the -a flag to specify a key.', fg='red')
        exit()
    
        weather = current_weather(location, api_key)
        print(f"The weather in {location} right now: {weather}.")
    
@main.command()
@click.pass_context
def config(ctx):
    """
    Store configuration values in a file, e.g. the API key for OpenWeatherMap.
    """
    config_file = ctx.obj['config_file']

    api_key = click.prompt(
        "Please enter your API key",
        default=ctx.obj.get('api_key', '')
    )
    
    if not re.match(r'[0-9a-f]{32}', api_key):
        click.echo(click.style(f'{api_key} is not a 32-character hexadecimal string.', fg='red'))
        exit()

    with open(config_file, 'w') as cfg:
        cfg.write(api_key)
    
main()

# Perform the following tests:

# delete the settings.cfg file if exists
# run python cli.py
# run python cli.py conf
# run python cli.py --co
# run python cli.py config and paste: invalid
# run python cli.py config and paste: b1b15e88fa797225412429c1c50c122a1
# run python cli.py config and check if there's a default value now
# run python cli.py current
# run python cli.py current lisbon