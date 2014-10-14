#ifndef PCFIELDONMESH_H_
#define PCFIELDONMESH_H_

/* person_in_charge: natacha.bereux at edf.fr */

#include <string>
#include <assert.h>

#include "MemoryManager/JeveuxCollection.h"
#include "MemoryManager/JeveuxVector.h"
#include "Mesh/Mesh.h"

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
        // Vecteur Jeveux '.NOMA'
        JeveuxVectorChar8       _meshName;
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
                                              _meshName( JeveuxVectorK8( name+".NOMA" ) ),
                                              _descriptor( JeveuxVectorLong( string( name+".DESC" ) ) ),
                                              _nameOfLigrels( JeveuxVectorChar24( string( name+".NOLI") ) ),
                                              _listOfMeshElements( JeveuxCollectionLong( string( name+".LIMA") ) ),
                                              _valuesList( JeveuxVector<ValueType>( string( name+".VALE") ) ), 
                                              _supportMesh( Mesh(false)) 
        {
            assert(name.size() == 19);
        };


        /**
        * Mise a jour des pointeurs Jeveux
        * @return true si la mise a jour s'est bien deroulee, false sinon
        */
        bool updateValuePointers()
        {
            bool retour = _meshName->updateValuePointer();
            retour = ( retour && _descriptor->updateValuePointer() );
            retour = ( retour && _valuesList->updateValuePointer() );
            // Les deux elements suivants sont facultatifs
            _listOfMeshElements->updateValuePointer();
            _nameOfLigrels->updateValuePointer();
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
