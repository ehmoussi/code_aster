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

subroutine ef0517(nomte)
!
!
! --------------------------------------------------------------------------------------------------
!
!                   EFGE_ELNO
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
    character(len=16) :: nomte
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/pmfinfo.h"
#include "asterfort/jevech.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer :: kp, adr, ncomp, i, cara, ne, jacf
    integer :: icgp, icontn, npg, istrxr, nc
    real(kind=8) :: fl(14), d1b3(2, 3), ksi1
    real(kind=8) :: sigfib
!
    integer :: nbfibr, nbgrfi, tygrfi, nbcarm, nug(10)
!
! --------------------------------------------------------------------------------------------------
!
    if (nomte .eq. 'MECA_POU_D_TGM') then
        call jevech('PCONTRR', 'L', icgp)
        call jevech('PSTRXRR', 'L', istrxr)
        call jevech('PEFFORR', 'E', icontn)
! --------------------------------------------------------------------------------------------------
!       Récupération des caractéristiques des fibres
        call pmfinfo(nbfibr,nbgrfi,tygrfi,nbcarm,nug,jacf=jacf)
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
!
        nc    =  7
        npg   =  3
        ncomp = 18
!       calcul des forces intégrées
        fl(:) = 0.0d+0
        do i = 1, nc
            do kp = 1, npg
                adr=istrxr+ncomp*(kp-1)+i-1
                fl(i)=fl(i)+zr(adr)*d1b3(1,kp)
                fl(i+nc)=fl(i+nc)+zr(adr)*d1b3(2,kp)
            enddo
        enddo
!
!       A cause de la plastification de la section les efforts n,mfy,mfz doivent être
!       recalculés pour les noeuds 1 et 2
        fl(1)=0.0d+0
        fl(5)=0.0d+0
        fl(6)=0.0d+0
        fl(1+nc)=0.0d+0
        fl(5+nc)=0.0d+0
        fl(6+nc)=0.0d+0
!
!       Pour les noeuds 1 et 2
!          calcul des contraintes
!          calcul des efforts generalises a partir des contraintes
        do ne = 1, 2
            do i = 1, nbfibr
                sigfib=0.0d+0
                do kp = 1, npg
                    adr=icgp+nbfibr*(kp-1)+i-1
                    sigfib=sigfib+zr(adr)*d1b3(ne,kp)
                enddo
                adr=nc*(ne-1)
                cara=jacf+(i-1)*nbcarm
                fl(1+adr)=fl(1+adr)+sigfib*zr(cara+2)
                fl(5+adr)=fl(5+adr)+sigfib*zr(cara+2)*zr(cara+1)
                fl(6+adr)=fl(6+adr)-sigfib*zr(cara+2)*zr(cara)
            enddo
        enddo
!
        do i = 1, 2*nc
            zr(icontn+i-1)=fl(i)
        enddo
!
    else if (nomte.eq.'MECA_POU_D_EM') then
        nc    =  6
        npg   =  2
        ncomp = 18
        call jevech('PSTRXRR', 'L', istrxr)
        call jevech('PEFFORR', 'E', icontn)
        kp = 1
        do i = 1,nc
            zr(icontn-1+nc*(kp-1)+i) = - zr(istrxr-1+ncomp*(kp-1)+i)
        enddo
        kp = 2
        do i = 1,nc
            zr(icontn-1+nc*(kp-1)+i) = zr(istrxr-1+ncomp*(kp-1)+i)
        enddo
    else if (nomte.eq.'MECA_POU_D_SQUE') then
        nc    =  9
        npg   =  2
        ncomp = 21
        call jevech('PSTRXRR', 'L', istrxr)
        call jevech('PEFFORR', 'E', icontn)
        kp= 1
        do i = 1,6
          zr(icontn-1+nc*(kp-1)+i) = - zr(istrxr-1+ncomp*(kp-1)+i)
        enddo
        do i = 7,nc
            zr(icontn-1+nc*(kp-1)+i) = - zr(istrxr-1+ncomp*(kp-1)+12+i)
        enddo
        kp= 2
        do i = 1,6
          zr(icontn-1+nc*(kp-1)+i) = zr(istrxr-1+ncomp*(kp-1)+i)
        enddo
        do i = 7,nc
            zr(icontn-1+nc*(kp-1)+i) = zr(istrxr-1+ncomp*(kp-1)+12+i)
        enddo

    else
        ASSERT(.false.)
    endif
!
end subroutine
