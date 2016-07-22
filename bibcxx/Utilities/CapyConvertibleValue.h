#ifndef CAPYCONVERTIBLEVALUE_H_
#define CAPYCONVERTIBLEVALUE_H_

/**
 * @file CapyConvertibleValue.h
 * @brief Fichier entete de la class CapyConvertibleValue
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */


#include <type_traits>
#include <typeinfo>
#include <map>
#include "astercxx.h"

#include "DataStructure/DataStructure.h"
#include "Mesh/Mesh.h"
#include "Utilities/GenericParameter.h"

/**
 * @typedef Definition d'un shared_ptr sur une DataStructure
 * @todo à déplacer dans DataStructure.h
 */
typedef boost::shared_ptr< DataStructure > DataStructurePtr;

/**
 * @typedef Definition d'un shared_ptr sur une VirtualMeshEntity
 * @todo à déplacer dans MeshEntity.h
 */
typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;

/**
 * @typedef Definition d'un std::vector sur un MeshEntityPtr
 * @todo à déplacer dans MeshEntity.h
 */
typedef std::vector< MeshEntityPtr > VectorOfMeshEntityPtr;

/**
 * @struct is_vector
 * @brief Classe template permettant de savoir si un type est un std::vector
 * @tparam T1 Type à tester
 */
template< typename T1 >
struct is_vector;

/**
 * @struct is_vector
 * @brief Spécialisation du template dans le cas général
 */
template< class T >
struct is_vector
{
    static bool const value = false;
    typedef T value_type;
};

/**
 * @struct is_vector
 * @brief Spécialisation du template dans le cas std::vector
 */
template< class T >
struct is_vector< std::vector<T> >
{
    static bool const value = true;
    typedef T value_type;
};


/**
 * @struct is_shared_ptr
 * @brief Classe template permettant de savoir si un type est un boost::shared_ptr
 * @tparam T1 Type à tester
 */
template< typename T1 >
struct is_shared_ptr;

/**
 * @struct is_shared_ptr
 * @brief Spécialisation du template dans le cas général
 */
template< class T >
struct is_shared_ptr
{
    static bool const value = false;
    typedef T value_type;
};

/**
 * @struct is_shared_ptr
 * @brief Spécialisation du template dans le cas boost::shared_ptr
 */
template< class T >
struct is_shared_ptr< boost::shared_ptr<T> >
{
    static bool const value = true;
    typedef T value_type;
};


/**
 * @struct is_vector_of_shared_ptr
 * @brief Classe template permettant de savoir si un type est un boost::shared_ptr
 * @tparam T1 Type à tester
 */
template< typename T1 >
struct is_vector_of_shared_ptr;

/**
 * @struct is_vector_of_shared_ptr
 * @brief Spécialisation du template dans le cas général
 */
template< class T >
struct is_vector_of_shared_ptr
{
    static bool const value = false;
    typedef T value_type;
};

/**
 * @struct is_vector_of_shared_ptr
 * @brief Spécialisation du template dans le cas boost::shared_ptr
 */
template< class T >
struct is_vector_of_shared_ptr< std::vector< boost::shared_ptr<T> > >
{
    static bool const value = true;
    typedef T value_type;
};

/**
 * @struct GenericCapyConvertibleValue
 * @brief Classe générique décrivant un mot-clé traduisible (classe mère permettant le stockage des filles)
 */
class GenericCapyConvertibleValue
{
protected:
    /** @brief Booléen qui permet de savoir si le mot-clé est activé */
    bool        _isSet;
    /** @brief Booléen qui permet de savoir si le mot-clé est obligatoire */
    bool        _isMandatory;
    /** @brief Nom du mot-clé */
    std::string _name;

public:
    /**
     * @brief Constructeur (ne permet pas de stocker une valeur)
     * @param isMandatory booléen permetant de dire si un mot-clé est obligatoire
     * @param keyword nom du mot-clé
     * @param isSet booléen permetant de dire si un mot-clé est activé
     */
    GenericCapyConvertibleValue( const bool isMandatory, const std::string keyword,
                                 bool isSet = false ): _isSet( isSet ),
                                                       _isMandatory( isMandatory ),
                                                       _name( keyword )
    {};

    /**
     * @brief Fonction permettant de desactiver le mot-clé
     */
    void disable()
    {
        _isSet = false;
    };

    /**
     * @brief Fonction permettant d'activer le mot-clé
     */
    void enable()
    {
        _isSet = true;
    };

    /**
     * @brief Fonction permettant de récupérer le nom du mot-clé
     * @return Nom du mot-clé
     */
    const std::string getNameOfKeyWord() const
    {
        return _name;
    };

protected:
    /**
     * @brief Fonction permettant de convertir le mot-clé en GenParam
     * @return Pointeur vers un GenParam
     * @warning la gestion du pointeur est déléguée à l'appelant !!
     */
    virtual GenParam* getValueOfKeyWord() const throw ( std::runtime_error )
    {
        throw std::runtime_error( "Programming error" );
        return new GenParam( "Base class", true );
    };

public:
    /**
     * @brief Fonction permettant de savoir si un mot-clé est obligatoire
     * @return true si obligatoire
     */
    const bool& isMandatory() const
    {
        return _isMandatory;
    };

    /**
     * @brief Fonction permettant de savoir si un mot-clé a été fixé
     * @return true si le mot-clé contient une valeur
     */
    const bool& isSet() const
    {
        return _isSet;
    };

    /**
     * @brief Fonction permettant de préciser si un mot-clé est obligatoire
     * @param isSet true s'il est obligatoire
     */
    void setMandatory( const bool& isMandatory )
    {
        _isMandatory = isMandatory;
    };

    friend class CapyConvertibleContainer;
};

/**
 * @class CapyConvertibleValue
 * @brief Classe décrivant un mot-clé traduisible pour n'importe quel type
 * @tparam Type type de donnée à convertir
 * @tparam MatchingType type correspondant à Type (dispose d'une valeur par défaut surchargeable)
 */
template< typename Type,
    // Pour les entiers, doubles, vecteurs d'entiers ou vecteurs de doubles,
    // le MatchingType sera le Type lui-même
    // Pour les vecteurs d'autres grandeurs, le MatchingType sera un vecteur std::string
    // Pour le reste, le MatchingType sera un std::string
          typename MatchingType = typename
                    std::conditional< std::is_same< Type, int >::value ||
                                      std::is_same< Type, double >::value ||
                                      std::is_same< Type, DoubleComplex >::value ||
                                      std::is_same< Type, std::vector< double > >::value ||
                                      std::is_same< Type, std::vector< DoubleComplex > >::value ||
                                      std::is_same< Type, std::vector< int > >::value,
                                      Type, typename
                                            std::conditional< is_vector< Type >::value,
                                                              std::vector< std::string >,
                                                              std::string >::type >::type >
class CapyConvertibleValue: public GenericCapyConvertibleValue
{
public:
    /** @typedef Definition du type de base de Type (dans le cas vecteur ::value_type) */
    typedef typename std::conditional< is_vector< Type >::value,
                                       typename is_vector< Type >::value_type,
                                       Type >::type BaseType;

    /** @typedef Definition du type correspondant au type de base de Type (entier, double ou chaine) */
    typedef typename std::conditional< is_vector< MatchingType >::value,
                                       typename is_vector< MatchingType >::value_type,
                                       MatchingType >::type BaseMatchingType;

    typedef std::vector< BaseType > VectorOfBaseTypes;
    typedef typename VectorOfBaseTypes::const_iterator VectorOfBaseTypesCIter;

    typedef std::vector< BaseMatchingType > VectorOfBaseMatchingTypes;
    typedef typename VectorOfBaseMatchingTypes::const_iterator VectorOfBaseMatchingTypesCIter;

    typedef std::map< BaseType, BaseMatchingType > MapOfTypeMatchingTypes;
    typedef typename MapOfTypeMatchingTypes::const_iterator MapConstIterator;

private:
    /** @brief Pointeur vers la valeur à traduire */
    const Type&            _value;
    /** @brief Dictionnaire permettant la traduction dans les cas non scalaires */
    MapOfTypeMatchingTypes _matchingValues;

public:
    /**
     * @brief Constructeur
     * @param isMandatory Booléen permettant de dire si le mot-clé est obligatoire
     * @param keyword Nom du mot-clé
     * @param value Référence sur la valeur à traduire
     * @warning On parle bien d'une REFERENCE, la classe converve un pointeur sur la valeur
     * @warning La durée de vie de value doit être supérieure à celle du CapyConvertibleValue
     * @param val1 vecteur de type de base à traduire
     * @param val2 vecteur de type correspondant au type de base contenant les traductions capy
     * @param isSet Booléen permettant de dire si un mot-clé est actif
     */
    CapyConvertibleValue( const bool isMandatory, const std::string keyword, const Type& value,
                          const VectorOfBaseTypes val1, const VectorOfBaseMatchingTypes val2,
                          bool isSet = true ) throw ( std::runtime_error ):
        GenericCapyConvertibleValue( isMandatory, keyword, isSet ),
        _value( value )
    {
        if ( val1.size() != val2.size() )
            throw std::runtime_error( "Programming error" );
        VectorOfBaseMatchingTypesCIter curIter2 = val2.begin();
        for( const auto& curIter1 : val1 )
        {
            _matchingValues[ curIter1 ] = *curIter2;
            ++curIter2;
        }
    };

    /**
     * @brief Constructeur
     * @param isMandatory Booléen permettant de dire si le mot-clé est obligatoire
     * @param keyword Nom du mot-clé
     * @param value Référence sur la valeur à traduire
     * @warning On parle bien d'une REFERENCE, la classe converve un pointeur sur la valeur
     * @warning La durée de vie de value doit être supérieure à celle du CapyConvertibleValue
     * @param isSet Booléen permettant de dire si un mot-clé est actif
     */
    CapyConvertibleValue( const bool isMandatory, const std::string keyword,
                          const Type& value, bool isSet = true ):
        GenericCapyConvertibleValue( isMandatory, keyword, isSet ),
        _value( value )
    {};

private:
    /**
     * @brief Traducteur du mot-clé dans le cas entier, double, vecteur d'entiers et vecteur de doubles
     * @todo à modifier pour prendre en compte la traduction
     * @return Pointeur vers un GenParam
     * @warning la gestion du pointeur est déléguée à l'appelant !!
     */
    template< typename T = Type, typename M = MatchingType >
    typename std::enable_if< (std::is_same< T, int >::value ||
                             std::is_same< T, double >::value ||
                             std::is_same< T, DoubleComplex >::value ||
                             std::is_same< T, std::vector< double > >::value ||
                             std::is_same< T, std::vector< DoubleComplex > >::value ||
                             std::is_same< T, std::vector< int > >::value) &&
                             !std::is_same< M, std::string >::value, GenParam* >::type
    virtualGetValueOfKeyWord() const throw ( std::runtime_error )
    {
        if( _isSet )
            return new GenParam( _name, _value, _isMandatory );
        else
            return new GenParam( _name, _isMandatory );
    };

    template< typename T = Type, typename M = MatchingType >
    typename std::enable_if< ( std::is_same< T, int >::value ||
                               std::is_same< T, double>::value ) &&
                             std::is_same< M, std::string >::value, GenParam* >::type
    virtualGetValueOfKeyWord() const throw ( std::runtime_error )
    {
        MapConstIterator curIter = _matchingValues.find( _value );
        if ( curIter == _matchingValues.end() )
            throw std::runtime_error( "Programming error" );
        return new GenParam( _name, (*curIter).second, _isMandatory );
    };

    /**
     * @brief Traducteur du mot-clé dans le cas vecteur
     * @return Pointeur vers un GenParam
     * @warning la gestion du pointeur est déléguée à l'appelant !!
     */
    template< typename T = Type, typename M = MatchingType >
    typename std::enable_if< is_vector< T >::value &&
                             !std::is_same< T, std::vector< double > >::value &&
                             !std::is_same< T, std::vector< DoubleComplex > >::value &&
                             !std::is_same< T, std::vector< int > >::value &&
                             !( is_vector< T >::value &&
                               std::is_base_of< DataStructure,
                                                typename is_vector_of_shared_ptr< T >::value_type >::value ) &&
                             !std::is_same< T, std::vector< MeshEntityPtr > >::value &&
                             !std::is_same< T, std::vector< std::string > >::value, GenParam* >::type
    virtualGetValueOfKeyWord() const throw ( std::runtime_error )
    {
        MatchingType toReturn;
        for( const auto& curIter : _value )
        {
            MapConstIterator curIter2 = _matchingValues.find( curIter );
            if ( curIter2 == _matchingValues.end() )
                throw std::runtime_error( "Programming error" );
            toReturn.push_back( (*curIter2).second );
        }
        if( _isSet )
            return new GenParam( _name, toReturn, _isMandatory );
        else
            return new GenParam( _name, _isMandatory );
    };

    /**
     * @brief Traducteur du mot-clé dans le cas vecteur de std::string
     * @return Pointeur vers un GenParam
     * @warning la gestion du pointeur est déléguée à l'appelant !!
     */
    template< typename T = Type, typename M = MatchingType >
    typename std::enable_if< std::is_same< T, std::vector< std::string > >::value, GenParam* >::type
    virtualGetValueOfKeyWord() const throw ( std::runtime_error )
    {
        MatchingType toReturn;
        for( const auto& curIter : _value )
            toReturn.push_back( curIter );

        if( _isSet )
            return new GenParam( _name, toReturn, _isMandatory );
        else
            return new GenParam( _name, _isMandatory );
    };

    /**
     * @brief Traducteur du mot-clé dans le cas vecteur de DataStructurePtr ou de MeshEntityPtr
     * @return Pointeur vers un GenParam
     * @warning la gestion du pointeur est déléguée à l'appelant !!
     */
    template< typename T = Type, typename M = MatchingType >
    typename std::enable_if< std::is_same< T, std::vector< MeshEntityPtr > >::value ||
                             ( is_vector< T >::value &&
                               std::is_base_of< DataStructure,
                                                typename is_vector_of_shared_ptr< T >::value_type >::value ),
                             GenParam* >::type
    virtualGetValueOfKeyWord() const throw ( std::runtime_error )
    {
        MatchingType toReturn;
        for( const auto& curIter : _value )
            toReturn.push_back( (curIter)->getName() );

        if( _isSet )
            return new GenParam( _name, toReturn, _isMandatory );
        else
            return new GenParam( _name, _isMandatory );
    };

    /**
     * @brief Traducteur du mot-clé dans le cas d'un DataStructurePtr
     * @return Pointeur vers un GenParam
     * @warning la gestion du pointeur est déléguée à l'appelant !!
     */
    template< typename T = Type, typename M = MatchingType >
    typename std::enable_if< std::is_same< T, MeshEntityPtr >::value ||
                             ( is_shared_ptr< T >::value &&
                               std::is_base_of< DataStructure,
                                                typename is_shared_ptr< T >::value_type >::value ),
                             GenParam* >::type
    virtualGetValueOfKeyWord() const throw ( std::runtime_error )
    {
        if( _isSet )
            return new GenParam( _name, (_value)->getName(), _isMandatory );
        else
            return new GenParam( _name, _isMandatory );
    };

    /**
     * @brief Traducteur du mot-clé dans les cas restants
     * @return Pointeur vers un GenParam
     * @warning la gestion du pointeur est déléguée à l'appelant !!
     */
    template< typename T = Type, typename M = MatchingType >
    typename std::enable_if< !std::is_same< T, int >::value &&
                             !std::is_same< T, double >::value &&
                             !std::is_same< T, DoubleComplex >::value &&
                             !std::is_same< T, std::vector< double > >::value &&
                             !std::is_same< T, std::vector< DoubleComplex > >::value &&
                             !std::is_same< T, std::vector< int > >::value &&
                             !is_vector< T >::value &&
                             !( is_vector< T >::value &&
                               std::is_base_of< DataStructure,
                                                typename is_vector_of_shared_ptr< T >::value_type >::value ) &&
                             !std::is_same< T, std::vector< MeshEntityPtr > >::value &&
                             !( is_shared_ptr< T >::value &&
                                std::is_base_of< DataStructure,
                                                 typename is_shared_ptr< T >::value_type >::value ) &&
                             !std::is_same< T, MeshEntityPtr >::value &&
                             !std::is_same< T, std::string >::value, GenParam* >::type
    virtualGetValueOfKeyWord() const throw ( std::runtime_error )
    {
        MapConstIterator curIter = _matchingValues.find( _value );
        if ( curIter == _matchingValues.end() )
            throw std::runtime_error( "Programming error" );
        return new GenParam( _name, (*curIter).second, _isMandatory );
    };

    /**
     * @brief Traducteur du mot-clé dans les cas des std::string
     * @return Pointeur vers un GenParam
     * @warning la gestion du pointeur est déléguée à l'appelant !!
     */
    template< typename T = Type, typename M = MatchingType >
    typename std::enable_if< std::is_same< T, std::string >::value, GenParam* >::type
    virtualGetValueOfKeyWord() const throw ( std::runtime_error )
    {
        return new GenParam( _name, _value, _isMandatory );
    };

    /**
     * @brief Traducteur du mot-clé
     * @return Pointeur vers un GenParam
     * @warning la gestion du pointeur est déléguée à l'appelant !!
     */
    GenParam* getValueOfKeyWord() const throw ( std::runtime_error )
    {
        return virtualGetValueOfKeyWord< Type, MatchingType >();
    };
};

/** @typedef Definition d'un shared_ptr sur un GenericCapyConvertibleValue */
typedef boost::shared_ptr< GenericCapyConvertibleValue > CapyValuePtr;

/**
 * @class CapyConvertibleContainer
 * @brief Classe contenant une liste de mots-clés à traduire
 */
class CapyConvertibleContainer
{
private:
    /** @typedef Definition d'un map associant le nom d'un GenericCapyConvertibleValue à l'objet */
    typedef std::map< std::string, CapyValuePtr > MapOfCapyValuePtr;
    /** @typedef Itérateur sur un MapOfCapyValuePtr */
    typedef MapOfCapyValuePtr::iterator MapOfCapyValuePtrIter;
    /** @typedef Itérateur constant sur un MapOfCapyValuePtr */
    typedef MapOfCapyValuePtr::const_iterator MapOfCapyValuePtrCIter;

    /** @typedef Map contenant les mots-clés */
    MapOfCapyValuePtr _container;

    std::string       _nameOfFKW;
    bool              _isFKW;
    ListGenParam      _toAdd;

    friend CapyConvertibleContainer operator+( const CapyConvertibleContainer&,
                                               const CapyConvertibleContainer& );

public:
    CapyConvertibleContainer(): _nameOfFKW( "" ),
                                _isFKW( false )
    {};

    CapyConvertibleContainer( const std::string& name ): _nameOfFKW( name ),
                                                         _isFKW( true )
    {};

    CapyConvertibleContainer( const std::string& name, const ListGenParam& list ):
        _nameOfFKW( name ),
        _isFKW( true ),
        _toAdd( list )
    {};

    /**
    * @brief Opérateur +=
    * @param toAdd SyntaxMapContainer à ajouter
    * @return reference to the current object 
    */
    CapyConvertibleContainer& operator+=( const CapyConvertibleContainer& toAdd )
    {
         _container.insert( toAdd._container.begin(), toAdd._container.end() );
         return *this;
    };

    /**
     * @brief Fonction permettant d'ajouter un GenericCapyConvertibleValue*
     * @param valueToAdd Pointeur à ajouter
     * @warning La responsabilité du pointeur est déléguée à la classe CapyConvertibleContainer
     */
    void add( GenericCapyConvertibleValue* valueToAdd )
    {
        _container[ valueToAdd->getNameOfKeyWord() ] = CapyValuePtr( valueToAdd );
    };

    /**
     * @brief Fonction permettant d'ajouter un CapyValuePtr
     * @param valueToAdd Smart pointeur à ajouter
     */
    void add( CapyValuePtr valueToAdd )
    {
        _container[ valueToAdd->getNameOfKeyWord() ] = valueToAdd;
    };

    std::string getName() const
    {
        return _nameOfFKW;
    };

    bool isFactorKeyword() const
    {
        return _isFKW;
    };

    /**
     * @brief Fonction permettant de récupérer un CapyValuePtr à partir de son nom
     * @param name Nom recherché
     */
    CapyValuePtr operator[]( const std::string& name ) throw ( std::runtime_error )
    {
        MapOfCapyValuePtrIter curIter = _container.find( name );
        if ( curIter == _container.end() )
            throw std::runtime_error( "Keyword " + name + " not available" );
        return curIter->second;
    };

    /**
     * @brief Supprimer un mot-clé
     * @param name Nom recherché
     * @return true si tout s'est bien passé
     * @deprecated Sera certainement supprimé plus tard
     */
    bool remove( const std::string& name )
    {
        MapOfCapyValuePtrIter curIter = _container.find( name );
        if ( curIter == _container.end() )
            return false;
        _container.erase( curIter );
        return true;
    };

    std::string setName( const std::string& name )
    {
        _nameOfFKW = name;
        _isFKW = true;
    };

    /**
     * @brief Permet de convertir le CapyConvertibleContainer en SyntaxMapContainer
     * @return Le SyntaxMapContainer résultat
     */
    SyntaxMapContainer toSyntaxMapContainer() const
    {
        ListGenParam lParam( _toAdd );
        for( const auto curIter : _container )
            if ( curIter.second->isSet() )
                lParam.push_back( curIter.second->getValueOfKeyWord() );

        SyntaxMapContainer toReturn = buildSyntaxMapFromParamList( lParam );

        for( auto curIter : lParam )
            delete curIter;
        return toReturn;
    };
};

/**
 * @brief Opérateur +
 * @param toAdd1 CapyConvertibleContainer à ajouter
 * @param toAdd2 CapyConvertibleContainer à ajouter
 * @return CapyConvertibleContainer résultat
 */
CapyConvertibleContainer operator+( const CapyConvertibleContainer& toAdd1,
                                    const CapyConvertibleContainer& toAdd2 );

class CapyConvertibleFactorKeyword
{
private:
    typedef std::vector< CapyConvertibleContainer > VectorCCC;
    typedef VectorCCC::const_iterator VectorCCCCIter;

    std::string _name;
    VectorCCC   _container;

public:
    CapyConvertibleFactorKeyword( std::string name ): _name( name )
    {};

    void addContainer( const CapyConvertibleContainer& toAdd )
    {
        _container.push_back( toAdd );
    };

    const std::string& getName() const
    {
        return _name;
    };

    /**
     * @brief Permet de convertir le CapyConvertibleFactorKeyword en ListSyntaxMapContainer
     * @return Le SyntaxMapContainer résultat
     */
    ListSyntaxMapContainer toSyntaxMapContainer() const
    {
        ListSyntaxMapContainer toReturn;
        for( auto curIter : _container )
            toReturn.push_back( curIter.toSyntaxMapContainer() );
        return toReturn;
    };
};

typedef std::map< std::string, CapyConvertibleFactorKeyword > MapStringCCFK;
typedef MapStringCCFK::const_iterator MapStringCCFKCIter;
typedef std::pair< std::string, CapyConvertibleFactorKeyword > PairStringCCFK;

class CapyConvertibleSyntax
{
private:
    CapyConvertibleContainer _skwContainer;
    MapStringCCFK            _fkwContainer;

public:
    CapyConvertibleSyntax()
    {};

    void addFactorKeywordValues( const CapyConvertibleFactorKeyword& toAdd )
    {
        _fkwContainer.insert( PairStringCCFK(toAdd.getName(), toAdd) );
    };

    void setSimpleKeywordValues( const CapyConvertibleContainer& toAdd )
    {
        _skwContainer = toAdd;
    };

    void addCapyConvertibleContainer( const CapyConvertibleContainer& toAdd )
        throw( std::runtime_error )
    {
        if( ! toAdd.isFactorKeyword() )
        {
            _skwContainer += toAdd;
        }
        else
        {
            if( toAdd.getName() == "" )
                throw std::runtime_error( "Programing error" );

            if( _fkwContainer.find( toAdd.getName() ) == _fkwContainer.end() )
            {
                CapyConvertibleFactorKeyword newCCFK( toAdd.getName() );
                _fkwContainer.insert( PairStringCCFK( toAdd.getName(), newCCFK ) );
            }
            auto iter = _fkwContainer.find( toAdd.getName() );
            (*iter).second.addContainer( toAdd );
        }
    };

    /**
     * @brief Permet de convertir le CapyConvertibleSyntax en SyntaxMapContainer
     * @return Le SyntaxMapContainer résultat
     */
    SyntaxMapContainer toSyntaxMapContainer() const
    {
        SyntaxMapContainer toReturn = _skwContainer.toSyntaxMapContainer();

        for( auto curIter : _fkwContainer )
            toReturn.container[ curIter.first ] = curIter.second.toSyntaxMapContainer();

        return toReturn;
    };
};

#endif /* CAPYCONVERTIBLEVALUE_H_ */
