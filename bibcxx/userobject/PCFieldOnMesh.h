#ifndef PCFIELDONMESH_H_
#define PCFIELDONMESH_H_

#include <string>
#include <assert.h>

#include "baseobject/JeveuxCollection.h"
#include "baseobject/JeveuxVector.h"
#include "userobject/Mesh.h"

/**
* class template Piecewise Constant (PC) Field on Mesh
*   Cette classe permet de definir une carte  (champ défini sur les mailles)
*/

template<class ValueType>
class PCFieldOnMeshInstance
{
    private:
        // Nom Jeveux de la carte
        string                  _name; 
        // Vecteur Jeveux '.DESC'
        JeveuxVectorLong        _descriptor;
        // Vecteur Jeveux '.NOLI'
        JeveuxVectorChar24      _nameOfLigrels;
        // Collection  '.LIMA'
        JeveuxCollectionLong    _listOfMeshElements;
        // Vecteur Jeveux '.VALE'
        JeveuxVector<ValueType> _valuesList;
        // Maillage sous-jacent 
        Mesh                    _supportMesh; 

    public:
        /**
        * Constructeur
        * @param name Nom Jeveux de la carte
        */
        PCFieldOnMeshInstance( string name ): _name( name ),
                                              _descriptor( JeveuxVectorLong( string( _jeveuxName+".DESC" ) ) ),
                                              _nameOfLigrels( JeveuxVectorChar24( string( _jeveuxName+".NOLI") ) ),
                                              _listOfMeshElements( JeveuxCollectionLong( string( _jeveuxName+".LIMA") ) ),
                                              _valuesList( JeveuxVector<ValueType>( string(_jeveuxName+".VALE") ) ), 
                                              _supportMesh( Mesh(false)) 
        {
            assert(name.size() == 19);
        };

        /**
        * Surcharge de l'operateur []
        * @param i Indice dans le tableau Jeveux
        * @return renvoie la valeur du tableau Jeveux a la position i
        */
        const ValueType &operator[](int i) const
        {
            return _valuesList->operator[](i);
        };

        /**
        * Mise a jour des pointeurs Jeveux
        * @return renvoit true si la mise a jour s'est bien deroulee, false sinon
        */
        bool updateValuePointers()
        {
           bool retour = _descriptor->updateValuePointer();
           retour = (retour && _nameOfLigrels->updateValuePointer()) ;
           retour = (retour &&  _listOfMeshElements->updateValuePointer());
           retour = (retour && _valuesList->updateValuePointer());
           return retour;
        };
        /**
        * Définition du maillage sous-jacent 
        * @param currentMesh objet Mesh sur lequel le modele reposera
        * @return renvoit true si la définition  s'est bien deroulee, false sinon
        */ 
        bool setSupportMesh(Mesh& currentMesh)
        {
            if ( currentMesh->isEmpty() )
                throw string("Mesh is empty");
            _supportMesh = currentMesh;
            return true;
        };
};

/**
* class template PCFieldOnMesh
*   Enveloppe d'un pointeur intelligent vers un PCFieldOnMeshInstance
*/
template<class ValueType>
class PCFieldOnMesh
{
    public:
        typedef boost::shared_ptr< PCFieldOnMeshInstance< ValueType > > PCFieldOnMeshTypePtr;

    private:
        PCFieldOnMeshTypePtr _PCFieldOnMeshPtr;

    public:
        PCFieldOnMesh(string nom): _PCFieldOnMeshPtr( new PCFieldOnMeshInstance< ValueType > (nom) )
        {};

        ~PCFieldOnMesh()
        {};

        PCFieldOnMesh& operator=(const PCFieldOnMesh< ValueType >& tmp)
        {
            _PCFieldOnMeshPtr = tmp._PCFieldOnMeshPtr;
        };

        const PCFieldOnMeshTypePtr& operator->(void) const
        {
            return _PCFieldOnMeshPtr;
        };

        bool isEmpty() const
        {
            if ( _PCFieldOnMeshPtr.use_count() == 0 ) return true;
            return false;
        };
};

typedef PCFieldOnMesh<double> PCFieldOnMeshDouble;

#endif /* PCFIELDONMESH_H_ */
