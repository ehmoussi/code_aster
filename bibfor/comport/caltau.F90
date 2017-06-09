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

subroutine caltau(ifa, is, sigf, fkooh,&
                  nfs, nsg, toutms, taus, mus,&
                  msns)
    implicit none
!
!     MONOCRISTAL : calcul de la scission reduite sur le systeme IS
!     IN  IFA    : NUMERO FAMILLE
!         IS     : NUMERO DU SYST. GLIS. ACTUEL
!         SIGF   : TENSEUR CONTRAINTES ACTUEL (TENSEUR S EN GDEF)
!     IN  FKOOH  : INVERSE TENSEUR HOOKE
!        TOUTMS  :  TOUS LES TENSEURS MUS=sym(MS*NS) en HPP,
!                   TOUS LES VECTEURS MS ET NS en gdef
!     OUT  TAUS  :  scission reduite sur le systeme IS
!     OUT  MUS   :  sym(MS * NS)
!     OUT  MSNS  :  MS * NS
!
#include "asterfort/lcprmv.h"
#include "asterfort/pmat.h"
#include "asterfort/tnsvec.h"
#include "blas/daxpy.h"
#include "blas/dscal.h"
    integer :: j, i, is, ifa, nfs, nsg
    real(kind=8) :: taus, mus(6), msns(3, 3), id6(6), ns(3), ms(3), sigf(6)
    real(kind=8) :: fesig(3, 3), s(3, 3), fetfe(3, 3), fetfe6(6)
    real(kind=8) :: toutms(nfs, nsg, 6), fkooh(6, 6)
    integer :: irr, decirr, nbsyst, decal, gdef
    common/polycr/irr,decirr,nbsyst,decal,gdef
!     ----------------------------------------------------------------
    data id6/1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/
!
!
    if (gdef .eq. 0) then
!
!        CALCUL DE LA SCISSION REDUITE =
!        PROJECTION DE SIG SUR LE SYSTEME DE GLISSEMENT
!        TAU      : SCISSION REDUITE TAU=SIG:MUS
!
        do i = 1, 6
            mus(i)=toutms(ifa,is,i)
        end do
        taus=0.d0
        do i = 1, 6
            taus=taus+sigf(i)*mus(i)
        end do
    else
!
!        CONTRAINTES PK2
! Y contient : SIGF=PK2 (sans les SQRT(2) !), puis les alpha_s
        call lcprmv(fkooh, sigf, fetfe6)
        call dscal(6, 2.d0, fetfe6, 1)
        call daxpy(6, 1.d0, id6, 1, fetfe6,&
                   1)
!
        do i = 1, 3
            ms(i)=toutms(ifa,is,i)
            ns(i)=toutms(ifa,is,i+3)
        end do
!
        do i = 1, 3
            do j = 1, 3
                msns(i,j)=ms(i)*ns(j)
            end do
        end do
!
        call tnsvec(6, 3, fetfe, fetfe6, 1.d0)
        call tnsvec(6, 3, s, sigf, 1.d0)
!
        call pmat(3, fetfe, s, fesig)
!
        taus=0.d0
        do i = 1, 3
            do j = 1, 3
                taus=taus + fesig(i,j)*msns(i,j)
            end do
        end do
!
    endif
!
end subroutine
