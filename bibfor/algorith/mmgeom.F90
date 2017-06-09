! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine mmgeom(ndim  ,nne   ,nnm   ,ffe   ,ffm   , &
                  geomae,geomam,tau1  ,tau2  , &
          norm  ,mprojn,mprojt,geome ,geomm )
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/mmcaln.h"
#include "asterfort/vecini.h"
#include "asterfort/assert.h"
    integer :: ndim, nne, nnm
    real(kind=8) :: ffe(9), ffm(9)
    real(kind=8) :: norm(3), tau1(3), tau2(3)
    real(kind=8) :: mprojn(3, 3), mprojt(3, 3)
    real(kind=8) :: geomm(3), geome(3)
    real(kind=8) :: geomae(9, 3), geomam(9, 3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCUL DES INCREMENTS - GEOMETRIE
!
! ----------------------------------------------------------------------
!
!
! DEPDEL - INCREMENT DE DEPLACEMENT DEPUIS DEBUT DU PAS DE TEMPS
! DEPMOI - DEPLACEMENT DEBUT DU PAS DE TEMPS
! GEOMAx - GEOMETRIE ACTUALISEE GEOM_INIT + DEPMOI
!
!
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
! IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
! IN  FFE    : FONCTIONS DE FORMES DEPL. ESCL.
! IN  FFM    : FONCTIONS DE FORMES DEPL. MAIT.
! IN  DDFFM  : DERIVEES SECONDES DES FONCTIONS DE FORME MAITRES
! IN  GEOMAE : GEOMETRIE ACTUALISEE SUR NOEUDS ESCLAVES
! IN  GEOMAM : GEOMETRIE ACTUALISEE SUR NOEUDS MAITRES
! IN  TAU1   : PREMIER VECTEUR TANGENT
! IN  TAU2   : SECOND VECTEUR TANGENT
! OUT NORM   : NORMALE INTERIEURE
! OUT GEOME  : COORDONNEES ACTUALISEES DU POINT DE CONTACT
! OUT GEOMM  : COORDONNEES ACTUALISEES DU PROJETE DU POINT DE CONTACT
!
! ----------------------------------------------------------------------
!
    integer :: idim, inoe, inom
!
! ----------------------------------------------------------------------
!
!
!
! --- INITIALISATIONS
!
    call vecini(3, 0.d0, geome)
    call vecini(3, 0.d0, geomm)
!
! --- COORDONNEES ACTUALISEES DU POINT DE CONTACT
!
    do  idim = 1, ndim
        do 12 inoe = 1, nne
            geome(idim) = geome(idim) + ffe(inoe)*geomae(inoe,idim)
12      continue
  end do
!
! --- COORDONNEES ACTUALISEES DE LA PROJECTION DU POINT DE CONTACT
!
    do  idim = 1, ndim
        do 22 inom = 1, nnm
            geomm(idim) = geomm(idim) + ffm(inom)*geomam(inom,idim)
22      continue
  end do
!
! --- CALCUL DE LA NORMALE ET DES MATRICES DE PROJECTION
!
    call mmcaln(ndim  ,tau1  ,tau2  ,norm  ,mprojn, &
                mprojt)



end subroutine
