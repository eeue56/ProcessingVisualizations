from relationships import map_words

from codecs import open as open_


def dataset_size(dataset):
    return sum(word.number_of_connections() for word in dataset.values())

def ratio_of_usage(word, data_size):
    return (word.number_of_connections() + 0.0) / data_size

def absolute_ratings(shared_words, dataset_1, dataset_2):

    ratings = dict((word, {'before' : 0, 'after' : 0}) for word in shared_words)

    for word, dic in ratings.iteritems():
        dic['before'] = dataset_1[word].ratio_of_befores
        dic['after'] = dataset_1[word].ratio_of_afters

    return ratings

def perfect_matches(ratings):

    return [word for word, dic in ratings.iteritems() if dic['after'] == dic['before']]

def usage_ratings(shared_words, dataset_1, dataset_2):
    dataset_1_size = dataset_size(dataset_1)
    dataset_2_size = dataset_size(dataset_2)
    
    ratings = dict((word, 0.0) for word in shared_words)

    for word, value in ratings.iteritems():
        ratings[word] = ratio_of_usage(dataset_1[word], dataset_1_size) - ratio_of_usage(dataset_2[word], dataset_2_size)

    return ratings

def perfect_matches_by_ratio(ratings):

    return [word for word, dic in ratings.iteritems() if dic['after'] == 0.0 and dic['before'] == 0.0]

def is_near_value(rating, value):
    return rating <= value and -value <= rating

def all_near_usage_value(ratings, near_value):
    output = []
    for word, value in ratings.iteritems():
        if is_near_value(value, near_value):
            output.append(word)
    return output

def befores_near_absolute_value(ratings, near_value):
    output = []
    for word, dic in ratings.iteritems():
        if is_near_value(dic['before'], near_value):
            output.append(word)
    return output

def afters_near_absolute_value(ratings, near_value):
    output = []
    
    for word, dic in ratings.iteritems():
        if is_near_value(dic['after'], near_value):
            output.append(word)
    
    return output

def all_near_absolute_value(ratings, near_value):

    return [word for word in befores_near_absolute_value(ratings, near_value) if word in afters_near_absolute_value(ratings, near_value)]


def shared_words(datasets):
    words = []
    for word in datasets[0]:
        if all(word in dataset for dataset in datasets):
            words.append(word)
    return words

def test():

    alice_data = map_words(read_file('pg11.txt', open_, encoding='utf-8'))
    jekyll_data = map_words(read_file('pg42.txt', open_, encoding='utf-8'))

    alice_size = dataset_size(alice_data)
    jekyll_size = dataset_size(jekyll_data)

    words = shared_words([alice_data, jekyll_data])


    """print words
    print len(words)
    print len(alice_data)
    print len(jekyll_data)
    print sum(len(word) for word in words)  / len(words) + 0.0
    print sum(len(word) for word in alice_data)  / (len(alice_data) + 0.0)
    print sum(len(word) for word in jekyll_data)  / (len(jekyll_data) + 0.0)

    print perfect_matches(absolute_ratings(words, alice_data, jekyll_data))"""

    near_value = 0.001
    all_near_usage = all_near_usage_value(usage_ratings(words, alice_data, jekyll_data), near_value)
    """print all_near
    print len(all_near)"""

    absolute = absolute_ratings(words, alice_data, jekyll_data)
    print perfect_matches(absolute)
    all_near_absolute = all_near_absolute_value(absolute, near_value)
    
    #print len(all_near_absolute)

    for word in all_near_usage:
        if word in perfect_matches(absolute):
            print word

if __name__ == '__main__':
    
    from exporting import read_file
    test()

    

    
    
    
