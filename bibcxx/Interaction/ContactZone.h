#ifndef CONTACTZONE_H_
#define CONTACTZONE_H_

/**
 * @file ContactZone.h
 * @brief Fichier entete de la class ContactZone
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

#include "Mesh/Mesh.h"
#include "Utilities/CapyConvertibleValue.h"

class GenericContactZone
{
protected:
    CapyConvertibleContainer _toCapyConverter;

public:
    const CapyConvertibleContainer& getCapyConvertibleContainer() const
    {
        return _toCapyConverter;
    };
};

class ContactZoneInstance: public GenericContactZone
{
    /** @brief Pointeur intelligent vers un VirtualMeshEntity */
    typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
    typedef std::vector< MeshEntityPtr > VectorOfMeshEntityPtr;
    VectorOfMeshEntityPtr _master;
    VectorOfMeshEntityPtr _slave;

public:
    ContactZoneInstance()
    {
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( true, "GROUP_MA_MAIT", _master, true ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( true, "GROUP_MA_ESCL", _slave, true ) );
    };

    void addMasterGroupOfElements( std::string name )
    {
        _master.push_back( MeshEntityPtr( new GroupOfElements( name ) ) );
    };

    void addSlaveGroupOfElements( std::string name )
    {
        _slave.push_back( MeshEntityPtr( new GroupOfElements( name ) ) );
    };
};

typedef boost::shared_ptr< ContactZoneInstance > ContactZonePtr;

#endif /* CONTACTZONE_H_ */
