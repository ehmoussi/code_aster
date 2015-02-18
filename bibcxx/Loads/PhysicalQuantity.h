#ifndef PHYSICALQUANTITY_H_
#define PHYSICALQUANTITY_H_

/**
 * @file PhysicalQuantity.h
 * @brief Definition of the  Physical Quantities used in Code_Aster
 * @author Natacha Béreux
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

#include <list>
#include <map>
#include <set>
#include <stdexcept> 
#include <string>
#include "astercxx.h"


/**
 * @enum PhysicalQuantity_Enum
 * @brief Inventory of all physical quantities available in Code_Aster
 */
enum PhysicalQuantity_Enum { Force, Displacement, Pressure, Temperature };

/**
 * @enum Component_Enum 
 * @brief Inventory of components of the physical quantities listed in PhysicalQuantity_Enum 
 */
enum Component_Enum { Dx, Dy, Dz, Drx, Dry, Drz, Temp, MiddleTemp, Pres, Fx, Fy, Fz, Mx, My, Mz };

/**
* @def ComponentNames
* @brief Aster names of the components of the physical quantities
*/
extern const char* ComponentNames[15];

/**
* @class PhysicalQuantityTraits
* @brief Traits class for a Physical Quantity
*/
/* This is the most general case (defined but intentionally not implemented) */
/* It will be specialized for each physical quantity listed in the inventory */

template < PhysicalQuantity_Enum PQ > struct PhysicalQuantityTraits; 

/****************************************/
/*            Force                     */
/****************************************/

/**
 * @def nbForceComponents
 * @brief Number of components specifying a force 
 */
const int nbForceComponents = 6;
/**
 * @def ForceComponents
 * @brief Declare Force Components 
 */
extern const Component_Enum ForceComponents[nbForceComponents];

/** @def PhysicalQuantityTraits <Force>
*  @brief Declare specialization for Force
*/

template <> struct PhysicalQuantityTraits <Force>
{
    static const std::set< Component_Enum > components;
    static const std::string name;
};

/****************************************/
/*        Displacement                  */
/****************************************/

/**
 * @def nbDisplComponents
 * @brief Number of components specifying a displacement 
 */
const int nbDisplacementComponents = 6;

/**
 * @def DisplComponents
 * @brief Declare Displacement Components 
 */
extern const Component_Enum DisplacementComponents[nbDisplacementComponents];

template <> struct PhysicalQuantityTraits <Displacement>
{
    static const std::set< Component_Enum > components;
    static const std::string name;
};

/******************************************/
/* @class PhysicalQuantityInstance
/* @brief Defines a physical quantity 
/******************************************/

template< class ValueType, PhysicalQuantity_Enum PhysicalQuantity >

class PhysicalQuantityInstance
{
    public:
    /** @typedef Define the Traits type */
    typedef PhysicalQuantityTraits<PhysicalQuantity> Traits;
    /** @typedef Value type of the physical quantity (double, function ...) */
    typedef ValueType QuantityType;
    /** @typedef Components and Values of the PhysicalQuantityInstance */
    typedef typename std::map< Component_Enum, QuantityType > MapOfCompAndVal;
    typedef typename MapOfCompAndVal::iterator MapIt;
    typedef typename std::pair<Component_Enum, QuantityType> CompAndVal;

    /* @def  */
    MapOfCompAndVal  _compAndVal;
    
    /** 
    * @brief Constructor
    */
    PhysicalQuantityInstance(){};
    
    /**
    * @brief Destructor
    */
     ~PhysicalQuantityInstance(){};
     
    /**
    * @function hasComponent
    * @brief test if a component is authorized for the physical quantity
    */
    
    static bool hasComponent( Component_Enum comp )
    {
        if ( Traits::components.find( comp ) == Traits::components.end() ) return false;
        return true;
    }
    
    void setValue( Component_Enum comp, QuantityType val )
    {
    if ( ! hasComponent( comp ) ) 
        {
            throw std::runtime_error( "This component is not allowed for the current Physical Quantity" );
        }
    /* On teste le retour de map.insert pour savoir si le terme existe déjà */ 
    std::pair< MapIt , bool> ret = _compAndVal.insert( CompAndVal( comp, val ) );
    if (! ret.second )
        {
    /* S'il existe déjà, on le retire et on le remplace par un nouveau */
      _compAndVal.erase( comp );
      _compAndVal.insert( CompAndVal( comp, val ) ); 
        }
    }

    /**
    * @brief debugPrint 
    */
    void debugPrint() const
    {
        std::cout << "Nom de la grandeur physique : " << Traits::name << std::endl; 
        std::cout << "Nb de composantes   : " << Traits::components.size() << std::endl;
        std::cout << "Nom des composantes : " ;
        for (std::set<Component_Enum>::iterator it(Traits::components.begin());
        it!=Traits::components.end(); it++)
        {
        std::cout << ComponentNames[*it] << " , " ; 
        }
        std::cout << std::endl; 
        for ( typename MapOfCompAndVal::const_iterator it(_compAndVal.begin()); 
            it!= _compAndVal.end(); it++)
        {
        std::cout << ComponentNames[it->first] << " : " << it->second << std::endl; 
        }
    };
    
    /**
     * @brief getMap
     * @return Map storing components and values of the physical quantity 
     */
    const MapOfCompAndVal& getMap() const
    {
      return _compAndVal; 
    };
    
    /** 
    * @brief get the name of the PhysicalQuantity
    */
    
    std::string getName() const
    {
    return Traits::name; 
    };
};


/**********************************************************/
/*  Explicit instantiation of template classes
/**********************************************************/

/** @typedef ForceDouble FORC_R */
template class PhysicalQuantityInstance< double, Force >; 
typedef PhysicalQuantityInstance< double, Force > ForceDoubleInstance;
typedef boost::shared_ptr< ForceDoubleInstance > ForceDoublePtr; 

/** @typedef DisplacementDouble DEPL_R */
template class PhysicalQuantityInstance< double, Displacement >; 
typedef PhysicalQuantityInstance< double, Displacement > DisplacementDoubleInstance;
typedef boost::shared_ptr< DisplacementDoubleInstance > DisplacementDoublePtr; 


#endif /* PHYSICALQUANTITY_H_ */
