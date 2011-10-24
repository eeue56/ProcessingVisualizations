from Countries import Country

def read_leaders(filename):
    
    countries = dict()
    
    with open(filename, 'r') as f:
        for line in f.readlines()[1:]:
            name, height, rubbish , country = [piece.strip() for piece in line.split(',')]
            if country not in countries:
                countries[country] = Country(country)
            countries[country].add_member(name, height)
            
    return countries
                
                
def main(filename):
    
    countries = read_leaders(filename)
    for country in countries.values():
        print country.name            
        print 'Number of members: {}'.format(country.number_of_members())
        print 'The tallest member is {}, who is {}cm'.format(country.tallest_member(),country.tallest_height())
        print 'The shortest member is {}, who is {}cm'.format(country.shortest_member(),country.shortest_height())
        print 'The average height is {:2g}cm'.format(country.average_height())
        print '\n\n'
       


if __name__ == '__main__':
    main("HEIGHTS OF LEADERS.csv")
