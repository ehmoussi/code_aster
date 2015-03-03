# coding: utf-8

class Rule:
    def __init__( self, curTuple ):
        if type( curTuple ) != tuple:
            raise NameError( 'Bad type ' + str( type( curTuple ) ) )
        self.ruleList = curTuple

    def __repr__( self ):
        return "%s( %r )" % ( self.__class__, self.ruleList )

class AtLeastOne( Rule ):
    def __init__( self, curTuple ):
        Rule.__init__( self, curTuple )

    def check( self, dictSyntax ):
        if type( dictSyntax ) != dict:
            raise NameError( 'Bad type' )

        present = False
        for value in self.ruleList:
            if dictSyntax.has_key(value): present = True
        if not present:
            raise NameError( "Syntax error - At least one in " + str( self.ruleList ) )

def AU_MOINS_UN( *args ):
    return AtLeastOne( args )

class OneIn( Rule ):
    def __init__( self, curTuple ):
        Rule.__init__( self, curTuple )

    def check( self, dictSyntax ):
        if type( dictSyntax ) != dict:
            raise NameError( 'Bad type' )

        count = 0
        for value in self.ruleList:
            if dictSyntax.has_key(value): count += 1
        if count != 1:
            raise NameError( "Syntax error - Must have just one in " + str( self.ruleList ) )

def UN_PARMI( *args ):
    return OneIn( args )

class Exclusion( Rule ):
    def __init__( self, curTuple ):
        Rule.__init__( self, curTuple )

    def check( self, dictSyntax ):
        if type( dictSyntax ) != dict:
            raise NameError( 'Bad type' )

        count = 0
        for value in self.ruleList:
            if dictSyntax.has_key(value): count += 1
        if count > 1:
            raise NameError( "Syntax error - Must have just one in " + str( self.ruleList ) )

def EXCLUS( *args ):
    return Exclusion( args )

class AllPresent( Rule ):
    def __init__( self, curTuple ):
        Rule.__init__( self, curTuple )

    def check( self, dictSyntax ):
        if type( dictSyntax ) != dict:
            raise NameError( 'Bad type' )

        present = False
        if dictSyntax.has_key( self.ruleList[0] ):
            present = True

        if present:
            for value in self.ruleList:
                if not dictSyntax.has_key(value):
                    raise NameError( "Syntax error - Must have all in " + str( self.ruleList ) )

def PRESENT_PRESENT( *args ):
    return AllPresent( args )

class OnlyFirstPresent( Rule ):
    def __init__( self, curTuple ):
        Rule.__init__( self, curTuple )

    def check( self, dictSyntax ):
        if type( dictSyntax ) != dict:
            raise NameError( 'Bad type' )

        present = False
        if dictSyntax.has_key( self.ruleList[0] ):
            present = True

        if present:
            for value in self.ruleList[1:]:
                if dictSyntax.has_key(value):
                    raise NameError( "Syntax error - " + self.ruleList[0] + " forbiden with " + value )

def PRESENT_ABSENT( *args ):
    return OnlyFirstPresent( args )

class AllTogether( Rule ):
    def __init__( self, curTuple ):
        Rule.__init__( self, curTuple )

    def check( self, dictSyntax ):
        if type( dictSyntax ) != dict:
            raise NameError( 'Bad type' )

        present = False
        for value in self.ruleList:
            if dictSyntax.has_key( value ):
                present = True
                break

        if present:
            for value in self.ruleList:
                if not dictSyntax.has_key(value):
                    raise NameError( "Syntax error - " + value + " is missing " )

def ENSEMBLE( *args ):
    return AllTogether( args )
