import json
import csv
from string import capwords

class PoorlyFormattedError(Exception):
    pass

def convert(input_name, output_name, dialect=None, order=None, exceptions=None):
    """Converts input_name from json to csv
        and stores in output_name"""

    if exceptions is None:
        exceptions = tuple()

    if dialect is None:
        dialect = 'excel'
    
    with open(input_name) as f:
        json_data = json.load(f)

    with open(output_name,'wb') as f:

        csv_file = csv.writer(f, dialect)
        rows = list()
        
        if order is None:
            headers = json_data[json_data.keys()[1]].keys()
        else:
            headers = order
            
        rows.append([capwords(header) for header in headers])
        
        for index in [key for key in json_data.keys() if key not in exceptions]:
            current_row = json_data[index]
            
            if order is None:
                rows.append([str(value) for value in current_row.values()])
            else:
                ordered_items = list()
                
                try:
                    for item in order:
                        ordered_items.append(str(current_row[item]))
                except KeyError:
                    raise PoorlyFormattedError('Input file is poorly formatted!')
                    
                rows.append(ordered_items)

        csv_file.writerows(rows)

if __name__ == '__main__':
    order = [u'title',
             u'annual_growth',
             u'life_expectancy_male',
             u'life_expectancy_female',
             u'life_expectancy_average',
             u'dev_status', u'birth_per_hour',
             u'death_per_hour',
             u'migration_per_hour',
             u'population']
    prefix = '../Data/'
    
    convert(prefix + 'country_data.json', prefix + 'country_data.csv', dialect='excel', order=order, exceptions=(u'world'))
