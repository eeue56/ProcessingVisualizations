class Country(object):

    def __init__(self, name):
        self.name = name
        self.members = dict()

    def __str__(self):
        return repr(self.name)

    def __repr__(self):
        return repr(self.members.values())
    
    def add_member(self, name, height_in_cm):
        if name in self.members:
            raise ValueError('A member with this name already exists!')
        self.members[name] = Member(name, height_in_cm)

    def add_members(self, members):
        for member in members:
            self.add_member(*member)

    def remove_member(self, name):
        if name not in self.members:
            raise ValueError('No member with this name exists!')
        del self.members[name]

    def remove_all_members(self):
        del self.members
        self.members = dict()

    def __verify_at_least_1_member(self):
        if self.number_of_members() == 0:
            raise ValueError('Must have at least one member!')

    def number_of_members(self):
        return len(self.members)

    def tallest_height(self):
        self.__verify_at_least_1_member()
        return max(member.height for member in self.members.values())

    def shortest_height(self):
        self.__verify_at_least_1_member()
        return min(member.height for member in self.members.values())

    def shortest_member(self):
        self.__verify_at_least_1_member()
        shortest_member = sorted(self.members.iteritems(), key=lambda (k, v): (v, k))[0]
        return shortest_member[0]

    def tallest_member(self):
        self.__verify_at_least_1_member()
        tallest_member = sorted(self.members.iteritems(), key=lambda (k, v): (v, k))[-1]
        return tallest_member[0]

    def average_height(self):
        self.__verify_at_least_1_member()
        return sum(member.height for member in self.members.values())/float(self.number_of_members())


class Member(object):

    def __init__(self, name, height_in_cm):
        if name == '':
            raise ValueError("Name must have a value!")
        self.name = name
        self.height = float(height_in_cm)

    def __str__(self):
        return repr(self.name)

    def __repr__(self):
        return repr('{name} : {height}'.format(name=self.name, height=self.height))


def test():
    country = Country('UK')
    country.add_members([('George',129),('Harry',140)])
    print repr(country)
    country.remove_all_members()
    print repr(country)
    
if __name__ == '__main__':
    test()
