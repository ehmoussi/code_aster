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

subroutine ef0347(nomte)
!     CALCUL DE EFGE_ELNO
!     ------------------------------------------------------------------
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
    character(len=16) :: nomte
    real(kind=8) :: ksi1, d1b3(2, 3)
    integer :: nc, i, npg
    integer :: icgp, icontn, kp, adr
    aster_logical :: okelem
!
!
! --- ------------------------------------------------------------------
!
    okelem=(nomte.eq.'MECA_POU_D_TG') .or.&
     &       (nomte.eq.'MECA_POU_D_T') .or. (nomte.eq.'MECA_POU_D_E')
    ASSERT(okelem)
!
    call elrefe_info(fami='RIGI',npg=npg)
    ASSERT((npg.eq.2) .or. (npg.eq.3))
!
    if (nomte .eq. 'MECA_POU_D_TG') then
        nc=7
    else
        nc=6
    endif

    call jevech('PCONTRR', 'L', icgp)
    call jevech('PEFFORR', 'E', icontn)
    
    if (nomte .eq. 'MECA_POU_D_E' .or. nomte .eq. 'MECA_POU_D_T')then
!        POUR LES POU_D_E ET POU_D_T :
!        RECOPIE DES VALEURS AU POINT GAUSS 1 ET [2|3]
!        QUI CONTIENNENT DEJA LES EFFORTS AUX NOEUDS
!           NPG=2 : RECOPIE DES POINTS 1 ET 2
!           NPG=3 : RECOPIE DES POINTS 1 ET 3
        if (npg .eq. 2) then
            do i = 1, nc
                zr(icontn-1+i)=zr(icgp-1+i)
                zr(icontn-1+i+nc)=zr(icgp-1+i+nc)
            enddo
        else
            do i = 1, nc
                zr(icontn-1+i)=zr(icgp-1+i)
                zr(icontn-1+i+nc)=zr(icgp-1+i+nc+nc)
            enddo
        endif
    else
!       On projette avec les fcts de forme sur les noeuds début et fin de l'élément
!       pour le point 1
        ksi1=-sqrt(5.d0/3.d0)
        d1b3(1,1)=ksi1*(ksi1-1.d0)/2.0d0
        d1b3(1,2)=1.d0-ksi1*ksi1
        d1b3(1,3)=ksi1*(ksi1+1.d0)/2.0d0
!       pour le point 2
        ksi1=sqrt(5.d0/3.d0)
        d1b3(2,1)=ksi1*(ksi1-1.d0)/2.0d0
        d1b3(2,2)=1.d0-ksi1*ksi1
        d1b3(2,3)=ksi1*(ksi1+1.d0)/2.0d0
    
!       calcul des forces intégrées
        do i = 1, nc
            do kp = 1, npg
                adr=icgp+nc*(kp-1)+i-1
                zr(icontn-1+i)=zr(icontn-1+i)+zr(adr)*d1b3(1,kp)
                zr(icontn-1+i+nc)=zr(icontn-1+i+nc)+zr(adr)*d1b3(2,kp)
            enddo
        enddo
    endif
    
!
end subroutine
