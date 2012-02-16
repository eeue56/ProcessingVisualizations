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

    @property
    def is_starting_word(self):
        return len(self.befores) == 0

    @property
    def is_ending_word(self):
        return len(self.afters) == 0

    def __eq__(self, other):
        return self.word == other.word

    def __str__(self):
        return '\nWord : {}\nBefores : {}\nAfters : {}\n'.format(self.word, self.befores, self.afters)

    def __repr__(self):
        return self.__str__()



def clean_line(line):

    return ''.join(letter for letter in line if letter not in ',')

def sentencify(data):

    sentences = []
    current_sentence = []


    for line in data:
        line = line.strip()
        
        line = [letter for letter in line if letter not in ':,()']

        if line == '':
                continue
            
        for word in clean_line(line).split():
            
            current_sentence.append(word)

            if any([word.endswith('.'), word.endswith('!'), word.endswith('?')]) :
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
            print current_word
            break

        current_word = data[choice(current_word.afters.keys())]
        sentence.append(current_word)

    return ' '.join(sentence)

if __name__ == '__main__':

    with open('data.txt') as f:
        data = [line for line in f if len(line.strip()) > 1]
        data = map_words(data)

    print make_sentence(data)
