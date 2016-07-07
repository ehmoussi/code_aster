#ifndef LOCALIZATIONMANEGER_H_
#define LOCALIZATIONMANEGER_H_

/**
 * @file LocalizationManager.h
 * @brief Fichier entete de la classe LocalizationManager
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
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

#include <string>
#include <boost/shared_ptr.hpp>

#include "Mesh/MeshEntities.h"
#include "Utilities/CapyConvertibleValue.h"

extern const char GROUP_MA[];
extern const char GROUP_NO[];

typedef CapyConvertibleValue< VectorOfMeshEntityPtr > LocalizationCapyConvertibleValue;
typedef boost::shared_ptr< LocalizationCapyConvertibleValue > LocalizationCapyConvertibleValuePtr;

class GenericLocalizationManager
{
private:
    std::string  _name;
    bool         _isMandatory;

protected:
    CapyValuePtr _skw;

public:
    GenericLocalizationManager( const std::string& name, const bool& mandatory ):
        _name( name ),
        _isMandatory( mandatory )
    {};

    void disable()
    {
        _skw->disable();
    };

    void enable()
    {
        _skw->enable();
    };

    std::string getName() const
    {
        return _name;
    };

    CapyValuePtr getCapyConvertibleValuePtr() const throw( std::runtime_error )
    {
        return _skw;
    };

    void setMandatory( const bool& mandatory )
    {
        _skw->setMandatory( mandatory );
    };
};

template< const char* tmp = GROUP_MA >
class GroupOfElementsManager: public GenericLocalizationManager
{
private:
    VectorOfMeshEntityPtr _vecOfGrp;

public:
    GroupOfElementsManager( const bool& mandatory = false ):
        GenericLocalizationManager( tmp, mandatory )
    {
        _skw = CapyValuePtr( new LocalizationCapyConvertibleValue( mandatory, std::string( tmp ),
                                                                   _vecOfGrp, false ) );
    };

    void addGroupOfElements( const std::string& name )
    {
        _vecOfGrp.push_back( GroupOfElementsPtr( new GroupOfElements( name ) ) );
        _skw->enable();
    };
};

template< const char* tmp = GROUP_NO >
class GroupOfNodesManager: public GenericLocalizationManager
{
private:
    VectorOfMeshEntityPtr _vecOfGrp;

public:
    GroupOfNodesManager( const bool& mandatory = false ):
        GenericLocalizationManager( tmp, mandatory )
    {
        _skw = CapyValuePtr( new LocalizationCapyConvertibleValue( mandatory, std::string( tmp ),
                                                                   _vecOfGrp, false ) );
    };

    void addGroupOfNodes( const std::string& name )
    {
        _vecOfGrp.push_back( GroupOfNodesPtr( new GroupOfNodes( name ) ) );
        _skw->enable();
    };
};

class AllMeshEntitiesManager: public GenericLocalizationManager
{
private:
    bool _on;

public:
    AllMeshEntitiesManager( const bool& mandatory = false ):
        GenericLocalizationManager( "TOUT", mandatory ),
        _on( false )
    {
        _skw = CapyValuePtr( new CapyConvertibleValue< bool >( mandatory, "TOUT", _on,
                                                               { true, false }, { "OUI", "NON" },
                                                               false ) );
    };

    void setOnAllMeshEntities()
    {
        _on = true;
        _skw->enable();
    };
};

template< typename... EntityLocalization >
class CapyLocalizationManager: public EntityLocalization...
{
private:
    template < class... B >
    typename std::enable_if< sizeof...(B) == 0, CapyConvertibleContainer >::type
    loopOverVariadicValues( CapyConvertibleContainer toReturn )
    {
        return toReturn;
    };

    template < class A, class... B >
    CapyConvertibleContainer
    loopOverVariadicValues( CapyConvertibleContainer toReturn = CapyConvertibleContainer() )
    {
        toReturn.add( A::getCapyConvertibleValuePtr() );
        return loopOverVariadicValues<B... >( toReturn );
    };

public:
    CapyLocalizationManager(): EntityLocalization()...
    {};

    CapyConvertibleContainer getCapyConvertibleContainer()
    {
        return loopOverVariadicValues< EntityLocalization... >();
    };
};

typedef CapyLocalizationManager< GroupOfElementsManager<>,
                                 GroupOfNodesManager<>,
                                 AllMeshEntitiesManager > AllNodesElementsLocalization;

typedef CapyLocalizationManager< GroupOfElementsManager<>,
                                 AllMeshEntitiesManager > AllElementsLocalization;

typedef CapyLocalizationManager< GroupOfElementsManager<>,
                                 GroupOfNodesManager<> > NodesElementsLocalization;

#endif /* LOCALIZATIONMANEGER_H_ */
