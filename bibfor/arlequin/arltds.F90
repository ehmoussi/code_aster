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

subroutine arltds(nns   ,npgs  , &
                  ipoids,icoors,ivfs  ,idfdes, &
                  poijcs,fctfs    ,dfdxs ,dfdys ,dfdzs )





    implicit none

#include "jeveux.h"
#include "asterfort/jemarq.h"
#include "blas/dcopy.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/jedema.h"

    integer :: nns,npgs
    integer :: ivfs,ipoids,idfdes,icoors
    real(kind=8) ::  poijcs(npgs)
    real(kind=8) ::  fctfs(npgs*nns)
    real(kind=8) ::  dfdxs(npgs*nns),dfdys(npgs*nns),dfdzs(npgs*nns)

! ----------------------------------------------------------------------

! CALCUL DES MATRICES DE COUPLAGE ARLEQUIN
! OPTION ARLQ_MATR

! CALCUL DES DERIVEES DES FF DE LA MAILLE SUPPORT S

! ----------------------------------------------------------------------


! IN  NNS    : NOMBRE DE NOEUDS DE LA MAILLE SUPPORT S
! IN  NPGS   : NOMBRE DE POINTS DE GAUSS DE LA MAILLE SUPPORT S
! IN  IPOIDS : POINTEUR VERS POIDS DE GAUSS DE LA MAILLE SUPPORT S
! IN  ICOORS : POINTEUR VERS COORD. NOEUDS DE LA MAILLE SUPPORT S
! IN  IVFS   : POINTEUR VERS FONCTIONS DE FORME DE LA MAILLE SUPPORT S
! IN  IDFDES : POINTEUR VERS DER. FONCTIONS DE FORME DE LA MAILLE S
! OUT POIJCS : POIDS DE GAUSS*JACOBIEN
! OUT FCTFS  : FONCTIONS DE FORME
! OUT DFDXS  : DER/X FONCTIONS DE FORME
! OUT DFDYS  : DER/Y FONCTIONS DE FORME
! OUT DFDZS  : DER/Z FONCTIONS DE FORME



    integer ::  mtl,kpgs

! ----------------------------------------------------------------------
    call jemarq()

! --- calcul des derivees de fct formes + jacobien transfo maille support

    do 10 kpgs = 1,npgs
        mtl  = nns*(kpgs-1)+1
        call dcopy(nns,zr(ivfs-1+mtl),1,fctfs(mtl)   ,1)
        call dfdm3d(nns       ,kpgs  ,ipoids,idfdes, &
                    zr(icoors), &
                    poijcs(kpgs)  , &
                    dfdxs(mtl)  , &
                    dfdys(mtl)   , &
                    dfdzs(mtl))
    10 end do

    call jedema()

end subroutine
