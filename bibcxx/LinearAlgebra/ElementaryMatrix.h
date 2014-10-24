#ifndef ELEMENTARYMATRIX_H_
#define ELEMENTARYMATRIX_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "DataStructure/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "Modelisations/Model.h"
#include "Materials/AllocatedMaterial.h"

class ElementaryMatrixInstance: public DataStructure
{
    private:
        // Objet Jeveux '.RERR'
        JeveuxVectorChar24 _description;
        // Objet Jeveux '.RELR'
        JeveuxVectorChar24 _listOfElementaryResults;
        // Booleen indiquant si la sd est vide
        bool               _isEmpty;
        // Modele support
        Model              _supportModel;
        // Champ de materiau a utiliser
        AllocatedMaterial  _material;

    public:
        /**
        * Constructeur
        */
        ElementaryMatrixInstance();

        /**
        * Destructeur
        */
        ~ElementaryMatrixInstance()
        {};

        bool computeMechanicalRigidity();

        void setAllocatedMaterial( const AllocatedMaterial& currentMaterial )
        {
            _material = currentMaterial;
        };

        void setSupportModel( const Model& currentModel )
        {
            _supportModel = currentModel;
        };
};

/**
* class ElementaryMatrix
*   Enveloppe d'un pointeur intelligent vers un ElementaryMatrix
* @author Nicolas Sellenet
*/
class ElementaryMatrix
{
    public:
        typedef boost::shared_ptr< ElementaryMatrixInstance > ElementaryMatrixPtr;

    private:
        ElementaryMatrixPtr _elementaryMatrixPtr;

    public:
        ElementaryMatrix(bool initialisation = true): _elementaryMatrixPtr()
        {
            if ( initialisation == true )
                _elementaryMatrixPtr = ElementaryMatrixPtr( new ElementaryMatrixInstance() );
        };

        ~ElementaryMatrix()
        {};

        ElementaryMatrix& operator=(const ElementaryMatrix& tmp)
        {
            _elementaryMatrixPtr = tmp._elementaryMatrixPtr;
            return *this;
        };

        const ElementaryMatrixPtr& operator->() const
        {
            return _elementaryMatrixPtr;
        };

        ElementaryMatrixInstance& operator*(void) const
        {
            return *_elementaryMatrixPtr;
        };

        bool isEmpty() const
        {
            if ( _elementaryMatrixPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* ELEMENTARYMATRIX_H_ */
