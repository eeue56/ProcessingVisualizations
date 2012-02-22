from relationships import map_words
from os import listdir

def export_data(data, filename):
    ''' Writes word information to filename'''

    with open(filename, 'w') as f:
        for word in data.values():
            f.write(','.join(str(x) for x in [word, len(word.befores), len(word.afters)]) + '\n')

def read_file(filename):
    with open(filename) as f:
        data = [line for line in f if len(line.strip()) > 1]
    return data

def export_all():

    data = {}
    
    for f in listdir('.'):
        if f.endswith('.txt'):
            read_data = read_file(f)
            map_words(read_data, data)

    export_data(data, 'all.txt')


if __name__ == '__main__':
    export_all()

    
