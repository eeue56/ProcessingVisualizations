# -*- coding: utf-8 -*-

from relationships import map_words
from simlar import absolute_ratings, usage_ratings, shared_words

from os import listdir
import codecs
import sys

def export_data(data, filename, func=open, *args, **kwargs):
    ''' Writes word information to filename'''

    with func(filename, 'w', *args, **kwargs) as f:
        for word in data.values():
            f.write(u','.join(unicode(x) for x in [word, len(word.befores), len(word.afters)]) + u'\n')


def export_shared_words(shared_words, usage_ratings, absolute_ratings, filename, func=open, *args, **kwargs):

    with func(filename, 'w', *args, **kwargs) as f:
        for word in shared_words:
            current_rating = absolute_ratings[word]
            f.write(u'|'.join(unicode(x) for x in [word, usage_ratings[word], current_rating['before'], current_rating['after']]) + u'\n')


def read_file(filename, func=open, *args, **kwargs):
    with func(filename, *args, **kwargs) as f:
        data = [unicode(line) for line in f if len(line.strip()) > 1]
        return data

def export_all():

    data = {}
    
    for f in listdir('.'):
        if f.endswith('.txt') and 'all' not in f:
            print f
            try:
                read_data = read_file(f, codecs.open, encoding='utf-8')
                map_words(read_data, data)
            except UnicodeDecodeError:
                pass
            

    export_data(data, 'all2.csv', codecs.open, encoding='utf-8')


if __name__ == '__main__':

    """
    data = read_file('svenska.txt', codecs.open, encoding='utf-8')
    data = map_words(data)
    export_data(data,'svenska.csv', codecs.open, encoding='utf-8')
    """

    alice_data = map_words(read_file('pg11.txt', codecs.open, encoding='utf-8'))
    jekyll_data = map_words(read_file('pg42.txt', codecs.open, encoding='utf-8'))

    words = shared_words([alice_data, jekyll_data])

    absolute = absolute_ratings(words, alice_data, jekyll_data)
    usage = usage_ratings(words, alice_data, jekyll_data)

    export_shared_words(words, usage, absolute, 'output_alice_jekyll_mix.csv', codecs.open, encoding='utf-8')
    
