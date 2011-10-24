class Country(object):

    def __init__(self, name):
        self.name = name
        self.members = dict()

    def __str__(self):
        return repr(self.name)

    def __repr__(self):
        return repr(self.members)
    
    def add_member(self, name, height_in_cm):
        if name in self.members:
            raise ValueError('A member with this name already exists!')
        self.members[name] = Member(name, height_in_cm)

    def remove_member(self, name):
        if name not in self.members:
            raise ValueError('No member with this name exists!')
        del self.members[name]

    def number_of_members(self):
        return len(self.members)

    def tallest_height(self):
        return max(member.height for member in self.members.values())

    def shortest_height(self):
        return min(member.height for member in self.members.values())

    def shortest_member(self):
        shortest_member = sorted(self.members.iteritems(), key=lambda (k, v): (v, k))[0]
        return shortest_member[0]

    def tallest_member(self):
        tallest_member = sorted(self.members.iteritems(), key=lambda (k, v): (v, k))[-1]
        return tallest_member[0]

    def average_height(self):
        return sum(member.height for member in self.members.values())/float(self.number_of_members())
    


class Member(object):

    def __init__(self, name, height_in_cm):
        self.name = name
        self.height = float(height_in_cm)

    def __str__(self):
        return repr(self.name)

    def __repr__(self):
        return repr(self.name + ' : ' + self.height)

if __name__ == '__main__':
    pass
