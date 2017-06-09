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

subroutine ejfono(ndim, nddl, axi, nno1, nno2,&
                  npg, ipg, wref, vff1, vff2,&
                  idf2, dffr2, geom, iu, ip,&
                  sigm, vect)
    implicit none
#include "asterf_types.h"
#include "asterfort/ejcine.h"
#include "asterfort/r8inir.h"
    aster_logical :: axi
    integer :: ndim, idf2, ipg, nddl, nno1, nno2, npg, iu(3, 16), ip(8)
    real(kind=8) :: vff1(nno1, npg), vff2(nno2, npg), geom(ndim, nno2)
    real(kind=8) :: wref(npg)
    real(kind=8) :: dffr2(ndim-1, nno2, npg)
    real(kind=8) :: vect(nddl), sigm(2*ndim-1, npg)
! ----------------------------------------------------------------------
!      OPTION FORC_NODA LES JOINTS QUADRA ET HYME
! ----------------------------------------------------------------------
! IN  NDIM    : DIMENSION DES ELEMENTS
! IN  NDDL    : NOMBRE DE DDL
! IN  AXI     : .TRUE. SI AXISYMETRIE
! IN  NNO1    : NOMBRE DE NOEUDS (FAMILLE U)
! IN  VFF1    : VALEUR DES FONCTIONS DE FORME (FAMILLE U)
! IN  NNO2    : NOMBRE DE NOEUDS (FAMILLE P)
! IN  VFF2    : VALEUR DES FONCTIONS DE FORME (FAMILLE P)
! IN  DFFR2   : DERIVEES DES FONCTIONS DE FORME DE REFERENCE (FAMILLE P)
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  WREF    : POIDS DES POINTS DE GAUSS DE REFERENCE
! IN  GEOM    : COORDONNEES DES NOEUDS
! IN  IU      : DECALAGE D'INDICE POUR ACCEDER AUX DDL DE DEPLACEMENT
! IN  IP      : DECALAGE D'INDICE POUR ACCEDER AUX DDL DE PRESSION
! OUT VECT    : FORCES INTERIEURES DE REFERENCE
! ----------------------------------------------------------------------
    integer :: kpg, n, i, j, kk
    real(kind=8) :: wg, b(2*ndim-1, ndim+1, 2*nno1+nno2), temp, rot(ndim*ndim)
! ----------------------------------------------------------------------
!
    call r8inir(nddl, 0.d0, vect, 1)
!
    do 999 kpg = 1, npg
!
        call ejcine(ndim, axi, nno1, nno2, vff1(1, kpg),&
                    vff2(1, kpg), wref(kpg), dffr2(1, 1, kpg), geom, wg,&
                    kpg, ipg, idf2, rot, b)
!
!
!       VECTEUR FINT : U
        do 300 n = 1, 2*nno1
            do 301 i = 1, ndim
!
                kk = iu(i,n)
                temp = 0.d0
                do j = 1, ndim
                    temp = temp + b(j,i,n)*sigm(j,kpg)
                enddo
!
                vect(kk) = vect(kk) + wg*temp
!
301         continue
300     continue
!
!       VECTEUR FINT : P
        do 302 n = 1, nno2
!
            kk = ip(n)
            temp = 0.d0
            do i = ndim+1, 2*ndim-1
                temp = temp + b(i,ndim+1,2*nno1+n)*sigm(i,kpg)
            enddo
!
            vect(kk) = vect(kk) + wg*temp
!
302     continue
!
999 continue
end subroutine
