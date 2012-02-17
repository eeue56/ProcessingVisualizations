from string import ascii_letters, ascii_uppercase
from random import choice

class Word(str):

    def __init__(self, word):
        self.word = word
        self.befores = dict()
        self.afters = dict()

    def add_before(self, other_word):
        if other_word not in self.befores:
            self.befores[other_word] = 0

        self.befores[other_word] += 1

    def add_after(self, other_word):
        if other_word not in self.afters:
            self.afters[other_word] = 0
        
        self.afters[other_word] += 1

    def _sort_connections_by_connections(self, group_dict):
        return sorted(group_dict.keys(), key=lambda key: key.number_of_connections) 

    @property
    def is_starting_word(self):
        return len(self.befores) == 0

    @property
    def is_ending_word(self):
        return len(self.afters) == 0

    @property
    def number_of_connections(self):
        return sum(self.afters.values()) + sum(self.befores.values())

    @property
    def most_paired_before(self):
        befores = sorted_dict(self.befores)
        return befores[-1][0]

    @property
    def most_paired_after(self):
        afters = sorted_dict(self.afters)
        return afters[-1][0]

    @property
    def most_connected_before(self):
        return self._sort_connections_by_connections(self.befores)[-1]
    
    @property
    def most_connected_after(self):
        return self._sort_connections_by_connections(self.afters)[-1]

    def __eq__(self, other):
        return self.word == other

    def __str__(self):
        return str(self.word)

   

    def __hash__(self):
        return hash(self.word)

def highest_connected_word(data):
    return sorted(data, key=lambda word : word.number_of_connections)[-1]

def sorted_dict(dictionary):
    return sorted([(k, v) for k, v in dictionary.iteritems()], key=lambda (k, v) : (v, k)) 

def clean_line(line):
    return ''.join(letter for letter in line if letter not in '')

def is_end_word(word):
    return any([word.endswith('.'), word.endswith('!'), word.endswith('?')])

def sentencify(data):

    sentences = []
    current_sentence = []

    for line in data:
        line = line.strip()
        
        line = clean_line(line)

        if line == '':
                continue
            
        for word in line.split():
            current_sentence.append(word)
            
            if is_end_word(word):
                sentences.append(' '.join(current_sentence))
                current_sentence = []

    return sentences

def split_into_groups(sentence):
    groups = []
    sentence = sentence.split()
    
    for x, word in enumerate(sentence):
        if x == 0:
            try:
                word_dict = {'after' : sentence[x + 1]}
            except IndexError:
                word_dict  = {}

        elif x == len(sentence) - 1:
            word_dict = {'before' : sentence[x - 1]}
        else:
            word_dict = {'after' : sentence[x + 1],
                         'before' : sentence[x - 1]}

        groups.append( {word : word_dict} )
            
    return groups

def map_words(file_name):

    words = dict()
    
    for sentence in sentencify(file_name):
        sentence = split_into_groups(sentence)

        for word_group in sentence:
            for word, word_dict in word_group.iteritems():
                if word not in words:
                    words[word] = Word(word)
                current_word = words[word]

                
                for key, sub_word in word_dict.iteritems():
                    if sub_word not in words:
                        words[sub_word] = Word(sub_word)
                    word_dict[key] = words[sub_word]
                
                if 'after' in word_dict:
                    current_word.add_after(word_dict['after'])
                if 'before' in word_dict:
                    current_word.add_before(word_dict['before'])
    return words

def make_sentence(data):
    sentence = []

    current_word = choice([word for word in data.values() if word.is_starting_word])
    sentence.append(current_word)

    while True:
        if not current_word.afters:
            break

        current_word = data[choice(current_word.afters.keys())]
        sentence.append(current_word)

    return ' '.join(sentence)

def make_longest_sentence(data):
    already_been = []
    
    current_word = highest_connected_word((word for word in data.values() if word.is_starting_word))

    while True:
        print current_word + ' ',
        already_been.append(current_word)

        for word in already_been:
            if word in current_word.afters:
                current_word = word
                break
        else:
            current_word = current_word.most_connected_after

        

if __name__ == '__main__':

    with open('pg42.txt') as f:
        data = [line for line in f if len(line.strip()) > 1]
        data = map_words(data)

    make_longest_sentence(data)
