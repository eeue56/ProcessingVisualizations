import csv
from string import capwords

def standardize(word, rules):
    """Standardizes a word based on a given rule list
    rules is a dict of rules where each key : value pair takes the form
    ideal_form : [unwanted_forms]
    Returns ideal form of the word if such a rule exists, returns the word
    given otherwise
    """

    
    if not any([word.lower() in values for values in rules.values()]):
        return word
    
    for ideal_form in rules:
        if word.lower() in rules[ideal_form]:
            return capwords(ideal_form)
    else:
        raise Exception("Something went seriously wrong somewhere!")

def generate_rule(string, delimiter=None):
    """ Generates a rule from a given string
        Basically, splits and the string based on delimiter (defaults to commas)
        and then returns the first list item (the key, ideal form) and the rest of
        the items as values (unwanted forms)
        N.B, list must produce at least 2 elements
    """
    if delimiter is None:
        delimiter = ','

    string = string.rstrip()
    string = string.split(delimiter)

    return string[0],string[1:]

def generate_rules(string_list, delimiter=None):
    """ Generates a rules dict from a given list of strings
        For each element in the list of strings, call generate_rule
        and then return a dict of the results
    """

    rules = dict()
    
    for string in string_list:
        key, values = generate_rule(string, delimiter)
        rules[key] = values
        
    return rules

def standardize_csv_file(csv_file, rules_file, dialect=None ):

    if dialect is None:
        dialect = 'excel'

    with open(rules_file,'rb') as f:
        rules = generate_rules(f.readlines())
        
    with open(csv_file,'rb') as f:
        csv_data = csv.reader(f,dialect)
        new_csv_data = list()
    
        for line in csv_data:
            current_row = list()
            for item in line:
                current_row.append(standardize(item, rules))
            new_csv_data.append(current_row)
        
    with open(csv_file,'wb') as f:
        csv_writer = csv.writer(f, dialect)
        csv_writer.writerows(new_csv_data)
            

if __name__ == '__main__':
    import time
    t = time.time()
    standardize_csv_file('../Data/country_data.csv', '../Data/Rules/country_names.csv')
    print time.time() - t 
