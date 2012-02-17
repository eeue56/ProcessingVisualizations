import json
import csv
from string import capwords

class PoorlyFormattedError(Exception):
    pass

def _clean_keys(keys, exceptions):
    """Returns version of keys without exceptions in"""
    return [key for key in keys if key not in exceptions]

def _clean_headers(headers):
    """Replaces underscores with spaces and then converts word sequence to capwords"""
    return [capwords(header.replace('_',' ')) for header in headers]

def _is_not_duplicate(item, been=[]):
    """Checks if item has already been processed
    Been is not to be passed - it uses a magical cache feature to check if item has been
    Returns False if item has been, true otherwise
    """
    
    if item in been:
        return False
    been.append(item)
    return True

def convert(input_name, output_name=None, dialect=None, order=None, exceptions=None, item_checker=None):
    """ Converts input_name from json to csv and stores in output_name
        If output name is not provided, then use the same filename as input
        Dialect is the dialect of the csv writer - defaults to excel
        Order is a list of the headers in some order to be written - not required
        Exceptions is a tuple of indexes to skip - these may be badly formed or useless
        Item checker is a function to ensure each row is correctly formated, if not, skip that row
        N.B, item cleaner must return false to skip, true to process.
        See the _is_not_duplicate method for why
    """

    if exceptions is None:
        exceptions = tuple()

    if item_checker is None:
        item_checker = lambda x: True

    if dialect is None:
        dialect = 'excel'

    if output_name is None:
        output_name = input_name[:input_name.find('.json')] + '.csv'

    with open(input_name) as f:
        json_data = json.load(f)

    with open(output_name,'wb') as f:

        csv_file = csv.writer(f, dialect)
        rows = list()

        keys = _clean_keys(json_data.keys(), exceptions)
        
        if order is None:
            headers = json_data[keys[0]].keys()
        else:
            headers = order[:]

        headers = _clean_headers(headers)
        rows.append(headers)
        
        for index in keys:
            current_row = json_data[index]
            
            if not item_checker(current_row[headers[0].lower()]):
                continue
            
            if order is None:
                rows.append(current_row.values())
            else:
                ordered_items = list()
                
                try:
                    for item in order:
                        ordered_items.append(current_row[item])
                except KeyError:
                    raise PoorlyFormattedError('Input file is poorly formatted!')
                    
                rows.append(ordered_items)

        csv_file.writerows(rows)

if __name__ == '__main__':
    order = (u'title',
             u'annual_growth',
             u'life_expectancy_male',
             u'life_expectancy_female',
             u'life_expectancy_average',
             u'dev_status',
             u'birth_per_hour',
             u'death_per_hour',
             u'migration_per_hour',
             u'population')
    prefix = '../Data/'
    
    convert(prefix + 'country_data.json',
            dialect='excel',
            order=order,
            exceptions=(u'world',),
            item_checker=_is_not_duplicate)
    
