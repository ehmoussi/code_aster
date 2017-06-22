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

subroutine arlted(ndim  , &
                  nns   ,jcoors, &
                  npgs  ,ivfs  ,idfdes,ipoids, &
                  elref1,ndml1   ,jcoor1, &
                  fcpig1    ,poijcs, &
                  dfdx1 ,dfdy1 ,dfdz1 )




    implicit none

#include "jeveux.h"
#include "asterfort/arltds.h"
#include "asterfort/arltep.h"

    integer :: ndim
    integer :: nns,npgs
    integer :: ivfs,ipoids,idfdes
    character(len=8) :: elref1
    integer :: ndml1,jcoor1,jcoors
    real(kind=8) ::  poijcs(npgs)
    real(kind=8) ::  fcpig1(npgs*ndim*ndim*ndml1)
    real(kind=8) ::  dfdx1(npgs*ndim*ndim*ndml1)
    real(kind=8) ::  dfdy1(npgs*ndim*ndim*ndml1)
    real(kind=8) ::  dfdz1(npgs*ndim*ndim*ndml1)

! ----------------------------------------------------------------------

! CALCUL DES MATRICES DE COUPLAGE ARLEQUIN
! OPTION ARLQ_MATR
! CALCUL DES FF ET DES DERIVEES DES FF DES MAILLES COUPLEES

! ----------------------------------------------------------------------


! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNS    : NOMBRE DE NOEUDS DE LA MAILLE SUPPORT S
! IN  NPGS   : NOMBRE DE POINTS DE GAUSS DE LA MAILLE SUPPORT S
! IN  IVFS   : POINTEUR VERS FONCTIONS DE FORME DE LA MAILLE SUPPORT S
! IN  IDFDES : POINTEUR VERS DER. FONCTIONS DE FORME DE LA MAILLE S
! IN  IPOIDS : POINTEUR VERS POIDS DE GAUSS DE LA MAILLE SUPPORT S
! IN  ELREF1 : ELREFE DE LA MAILLE 1
! IN  NDML1  : NOMBRE DE NOEUDS DE LA MAILLE 1
! IN  JCOOR1 : POINTEUR VERS COORD. NOEUDS DE LA MAILLE 1
! IN  ELREF2 : ELREFE DE LA MAILLE 2
! IN  NDML2  : NOMBRE DE NOEUDS DE LA MAILLE 2
! IN  JCOOR2 : POINTEUR VERS COORD. NOEUDS DE LA MAILLE 2
! OUT FCPIG1 : FCT. FORME DE MAILLE 1 AU POINT DE GAUSS KPGS
!               DE LA MAILLE S
! OUT POIJCS : POIDS DE GAUSS*VOLUME MAILLE SUPPORT
! OUT DFDXm  : DERIVEE FCT. FORME/X EN CHAQUE PT DE GAUSS DE LA MAILLE m
! OUT DFDYm  : DERIVEE FCT. FORME/Y EN CHAQUE PT DE GAUSS DE LA MAILLE m
! OUT DFDZm  : DERIVEE FCT. FORME/Z EN CHAQUE PT DE GAUSS DE LA MAILLE m


    integer :: kpgs
    integer :: mtl1
    real(kind=8) ::  fctfs(npgs*nns)
    real(kind=8) ::  dfdzs(npgs*nns),dfdxs(npgs*nns),dfdys(npgs*nns)

! ----------------------------------------------------------------------

! --- CALCUL DES DERIVEES DE FCT FORMES DES MAILLES COURANTES

    call arltds(nns   ,npgs  , &
                ipoids,jcoor1,ivfs  ,idfdes, &
                poijcs,fctfs    ,dfdxs ,dfdys ,dfdzs )

    do 12 kpgs = 1,npgs

        mtl1 = ndim*ndim*ndml1*(kpgs-1)+1
        call arltep(ndim  ,zr(jcoor1) ,npgs     ,kpgs      , &
                    nns   ,zr(ivfs)   , &
                    elref1,ndml1      ,zr(jcoor1), &
                    fcpig1(mtl1),dfdx1(mtl1) ,dfdy1(mtl1) , &
                    dfdz1(mtl1))

    12 end do


end subroutine
