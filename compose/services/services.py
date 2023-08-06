import yaml

services = [
    {
        'name': 'service1',
        'environment': {
            'VAR1': 'value1',
            'VAR2': 'value2'
        }
    },
    {
        'name': 'service2',
        'environment': {
            'VAR3': 'value3',
            'VAR4': 'value4'
        }
    },
    # Add more services and their environment variables as needed
]

compose_data = {
    'version': '3',
    'networks': {
        'my_network': {}
    },
    'services': {}
}

for service_data in services:
    service_name = service_data['name']
    compose_data['services'][service_name] = {
        'image': f'{service_name}:latest',
        'restart': 'always',
        'ports': [f'{8000 + i}:80' for i, _ in enumerate(services)],  # Assign unique host ports
        'environment': service_data['environment'],
        'networks': ['my_network'],
    }

with open('docker-compose.yml', 'w') as compose_file:
    yaml.dump(compose_data, compose_file)
