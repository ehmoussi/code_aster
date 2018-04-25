! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine dxsit3(nomte, mater, pgl, sigma)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dxmate.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/verift.h"
    integer :: mater
    real(kind=8) :: pgl(3, *), sigma(*)
    character(len=16) :: nomte
!
!     BUT:
!       CALCUL DES CONTRAINTES VRAIES
!        (==SIGMA_MECA - SIGMA_THER).
!
! ----------------------------------------------------------------------
!
    integer :: ndim, nnoel, nnos, npg, ipoids, icoopg, ivf, idfdx, idfd2, jgano
    integer :: i, j, icou, icpg, igauh, ipg, ipgh, nbcmp, nbcou
    integer :: npgh
    integer :: jnbspi, multic, jcaco
!
    real(kind=8) :: zero, epsth(2)
    real(kind=8) :: df(3, 3), dm(3, 3), dmf(3, 3), dc(2, 2), dci(2, 2)
    real(kind=8) :: dmc(3, 2), dfc(3, 2)
    real(kind=8) :: h(3, 3), d(4,4)
    real(kind=8) :: t2iu(4), t2ui(4), t1ve(9), epais
!
    character(len=4) :: fami
!
    aster_logical :: dkg, coupmf
!
! ----------------------------------------------------------------------
!
    fami = 'RIGI'
    call elrefe_info(fami=fami, ndim=ndim, nno=nnoel, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jcoopg=icoopg, jvf=ivf, jdfde=idfdx, jdfd2=idfd2,&
                     jgano=jgano)
!
    zero = 0.0d0
!
    dkg = .false.
!
    nbcmp = 6
!
    if ((nomte.eq.'MEDKTG3') .or. (nomte.eq.'MEDKQG4')) then
        dkg = .true.
    endif
!
! --- RECUPERATION DU NOMBRE DE COUCHE ET DE SOUS-POINT
!     -------------------------------------------------
    if (dkg) then
        nbcou = 1
        npgh = 1
    else
        call jevech('PNBSP_I', 'L', jnbspi)
        npgh = 3
        nbcou = zi(jnbspi-1+1)
        if (nbcou .le. 0) then
            call utmess('F', 'ELEMENTS_46')
        endif
    endif
    
!   ----- CARACTERISTIQUES DES MATERIAUX --------
    call dxmate(fami, df, dm, dmf, dc,&
                dci, dmc, dfc, nnoel, pgl,&
                multic, coupmf, t2iu, t2ui, t1ve)
!   ----- CALCUL DE LA MATRICE DE HOOKE EN MEMBRANE ---------------
    if (multic .eq. 0) then
        call jevech('PCACOQU', 'L', jcaco)
        epais = zr(jcaco)
        do i = 1, 3
            do j= 1, 3
                h(i,j) = dm(i,j)/epais
            enddo
        end do
    else
        ASSERT(.false.)
    endif
    
!   ---- passage a la matrice de hooke complete
    d(:,:) = 0.d0
    d(1:2,1:2) = h(1:2,1:2)
    d(1,4) = h(1,3)
    d(2,4) = h(2,3)
    d(4,4) = h(3,3)
    d(4,1) = h(3,1)
    d(4,2) = h(3,2)
!
! --- BOUCLE SUR LES POINTS DE GAUSS DE LA SURFACE:
!     ---------------------------------------------
    do ipg = 1, npg
        do icou = 1, nbcou
            do igauh = 1, npgh
                icpg=nbcmp*npgh*nbcou*(ipg-1)+ nbcmp*npgh*(icou-1)+&
                nbcmp*(igauh-1)
!
!         -- INTERPOLATION DE ALPHA EN FONCTION DE LA TEMPERATURE
!         ----------------------------------------------------
                ipgh=npgh*(icou-1)+igauh
                call verift('RIGI', ipg, ipgh, '+', mater,&
                            epsth_=epsth(1))
!
                epsth(2) = epsth(1)
!
!           -- CALCUL DES CONTRAINTES VRAIES (==SIGMA_MECA - SIGMA_THER)
!           -- AU POINT D'INTEGRATION COURANT
!           ------------------------------------------------------------
                do i = 1, 4
                    do j = 1, 2
                        sigma(icpg+i)=sigma(icpg+i)-epsth(j)*d(i,j)
                    end do
                end do
            end do
        end do
    end do
!
end subroutine
