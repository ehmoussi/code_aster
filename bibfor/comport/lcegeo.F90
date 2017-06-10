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

subroutine lcegeo(nno, npg, ipoids, ivf, idfde,&
                  geom, typmod, compor, ndim, dfdi,&
                  deplm, ddepl, elgeom)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/matinv.h"
#include "asterfort/nmgeom.h"
#include "asterfort/pmat.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "asterfort/mgauss.h"
#include "asterfort/r8inir.h"
#include "asterfort/utmess.h"
!
    integer :: nno, npg, ipoids, ivf, idfde, ndim, iret, jj
    character(len=8) :: typmod(2)
    character(len=16) :: compor(*)
    real(kind=8) :: geom(3, nno), elgeom(10, npg), dfdi(nno, 3)
    real(kind=8) :: deplm(3, nno), ddepl(3, nno), inv(3, 3), det, de, dn, dk
!
! ----------------------------------------------------------------------
!
! CALCUL D'ELEMENTS GEOMETRIQUES SPECIFIQUES AUX LOIS DE COMPORTEMENT
!
! ----------------------------------------------------------------------
!
!
! IN  NNO    : NOMBRE DE NOEUDS DE L'ELEMENT
! IN  NPG    : NOMBRE DE POINTS DE GAUSS
! IN  IPOIDS : POIDS DES POINTS DE GAUSS
! IN  IVF    : VALEUR  DES FONCTIONS DE FORME
! IN  IDFDE  : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
! IN  GEOM   : COORDONEES DES NOEUDS
! IN  TYPMOD : TYPE DE MODELISATION
! IN  COMPOR : COMPORTEMENT
!
! OUT ELGEOM  : TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES AUX LOIS
!               DE COMPORTEMENT (DIMENSION MAXIMALE FIXEE EN DUR, EN
!               FONCTION DU NOMBRE MAXIMAL DE POINT DE GAUSS)
!
!
!
!
    integer :: kpg, k, i, nddl, j
    real(kind=8) :: rac2, lc, dfdx(27), dfdy(27), dfdz(27), poids, r, r8bid
    real(kind=8) :: l(3, 3), fmm(3, 3), df(3, 3), f(3, 3)
    real(kind=8) :: volume, surfac
    real(kind=8) :: deplp(3, 27), geomm(3, 27), epsbid(6), id(3, 3)
    aster_logical :: laxi
    data    id/1.d0,0.d0,0.d0, 0.d0,1.d0,0.d0, 0.d0,0.d0,1.d0/
!
! ----------------------------------------------------------------------
!
! --- INITIALISATIONS
!
    rac2 = sqrt(2.d0)
    laxi = typmod(1) .eq. 'AXIS'
    nddl = ndim*nno
!
! --- CALCUL DE LA LONGUEUR CARACTERISTIQUE POUR LA LOI
! --- BETON_DOUBLE_DP
!
    if (compor(1)(1:15) .eq. 'BETON_DOUBLE_DP' .or.&
        (compor(1)(1:7) .eq. 'KIT_DDI' .and. compor(PLAS_NAME)(1:15) .eq. 'BETON_DOUBLE_DP' )) then
        if (typmod(1)(1:2) .eq. '3D') then
            volume = 0.d0
            do kpg = 1, npg
                call dfdm3d(nno, kpg, ipoids, idfde, geom,&
                            poids, dfdx, dfdy, dfdz)
                volume = volume + poids
            end do
            if (npg .ge. 9) then
                lc = volume ** 0.33333333333333d0
            else
                lc = rac2 * volume ** 0.33333333333333d0
            endif
        elseif(typmod(1)(1:6).eq.'D_PLAN' .or.typmod(1)(1:4).eq.'AXIS')then
            surfac = 0.d0
            do kpg = 1, npg
                k = (kpg-1)*nno
                call dfdm2d(nno, kpg, ipoids, idfde, geom,&
                            poids, dfdx, dfdy)
                if (laxi) then
                    r = 0.d0
                    do i = 1, nno
                        r = r + geom(1,i)*zr(ivf+i+k-1)
                    end do
                    poids = poids*r
                endif
                surfac = surfac + poids
            end do
!
            if (npg .ge. 5) then
                lc = surfac ** 0.5d0
            else
                lc = rac2 * surfac ** 0.5d0
            endif
!
           elseif(typmod(1)(1:6).eq.'C_PLAN') then
                call utmess('F', 'COMPOR5_51')
!
        else
            ASSERT(.false.)
        endif
!
        do kpg = 1, npg
            elgeom(1,kpg) = lc
        end do
    endif
!
! --- ELEMENTS GEOMETRIQUES POUR META_LEMA_INI
!
    if (compor(1)(1:13) .eq. 'META_LEMA_ANI') then
        if (laxi) then
            do kpg = 1, npg
                elgeom(1,kpg) = 0.d0
                elgeom(2,kpg) = 0.d0
                elgeom(3,kpg) = 0.d0
            end do
        else
            do kpg = 1, npg
                elgeom(1,kpg) = 0.d0
                elgeom(2,kpg) = 0.d0
                elgeom(3,kpg) = 0.d0
                do i = 1, ndim
                    do k = 1, nno
                        elgeom(i,kpg) = elgeom(i,kpg) + geom(i,k)*zr( ivf-1+nno*(kpg-1)+k)
                    end do
                end do
            end do
        endif
    endif
!
! --- ELEMENTS GEOMETRIQUES POUR MONOCRISTAL: ROTATION DU RESEAU
!
    if (compor(1) .eq. 'MONOCRISTAL') then
!       ROTATION RESEAU DEBUT
!       CALCUL DE L = DF*F-1
        call dcopy(nddl, geom, 1, geomm, 1)
        call daxpy(nddl, 1.d0, deplm, 1, geomm,&
                   1)
        call dcopy(nddl, deplm, 1, deplp, 1)
        call daxpy(nddl, 1.d0, ddepl, 1, deplp,&
                   1)
        do kpg = 1, npg
            call nmgeom(ndim, nno, .false._1, .true._1, geom,&
                        kpg, ipoids, ivf, idfde, deplp,&
                        .true._1, r8bid, dfdi, f, epsbid,&
                        r)
            call nmgeom(ndim, nno, .false._1, .true._1, geomm,&
                        kpg, ipoids, ivf, idfde, ddepl,&
                        .true._1, r8bid, dfdi, df, epsbid,&
                        r)
            call daxpy(9, -1.d0, id, 1, df,&
                       1)
            call matinv('S', 3, f, fmm, r8bid)
            call pmat(3, df, fmm, l)
            do i = 1, 3
                do j = 1, 3
                    elgeom(3*(i-1)+j,kpg)=l(i,j)
                end do
            end do
        end do
    endif
!
    if ((compor(1) .eq. 'ENDO_PORO_BETON') .or.&
        (&
        (compor(1) .eq. 'KIT_DDI') .and.&
        ((compor(CREEP_NAME).eq.'ENDO_PORO_BETON').or. (compor(PLAS_NAME).eq.'ENDO_PORO_BETON'))&
        )) then
!
        if (typmod(1)(1:2) .eq. '3D') then
!
            do kpg = 1, npg
                do i = 1, 3
                    l(1,i) = 0.d0
                    l(2,i) = 0.d0
                    l(3,i) = 0.d0
                    do  j = 1, nno
                        k = 3*nno*(kpg-1)
                        jj = 3*(j-1)
                        de = zr(idfde-1+k+jj+1)
                        dn = zr(idfde-1+k+jj+2)
                        dk = zr(idfde-1+k+jj+3)
                        l(1,i) = l(1,i) + de*geom(i,j)
                        l(2,i) = l(2,i) + dn*geom(i,j)
                        l(3,i) = l(3,i) + dk*geom(i,j)
                    end do
                end do
!
! --------- inversion de la matrice l
                iret = 0
                det = 0.d0
                call r8inir(9, 0.d0, inv, 1)
                do i = 1, 3
                    inv(i,i) = 1.d0
                end do
!
                call mgauss('NCVP', l, inv, 3, 3,&
                            3, det, iret)
!
                do i = 1, 3
                    do j = 1, 3
                        elgeom(3*(i-1)+j,kpg)=inv(i,j)
                    end do
                end do
            end do
!
        else
            call utmess('F', 'COMPOR1_92')
        endif
!
    endif
!
end subroutine
