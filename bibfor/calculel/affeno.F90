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

subroutine affeno(ioc, ino, nocmp, nbcmp, ncmpgd,&
                  ncmpmx, val, kval, desc, valglo,&
                  kvalgl, type, nec)
    implicit none
#include "asterc/indik8.h"
#include "asterfort/utmess.h"
    integer :: ino, nbcmp, ncmpmx, nec, desc(*), ioc
    real(kind=8) :: valglo(*), val(*)
    character(len=*) :: type
    character(len=8) :: nocmp(*), kvalgl(*), ncmpgd(*), kval(*)
    character(len=24) :: valk
!
!    ROUTINE UTILISEE PAR OP0052 (OPERATEUR AFFE_CHAM_NO)
!
!    CETTE ROUTINE AFFECTE LES COMPOSANTES NOCMP DU NOEUD INO AUX
!    VALEURS VAL DANS LE TABLEAU VALGLO
!    ELLE CALCULE EGALEMENT LE DESCRIPTEUR GRANDEUR DESC DU NOEUD INO
!
! IN  : IOC    : NUMERO DE L'OCCURENCE DE AFFE DANS LA COMMANDE
! IN  : INO    : NUMERO DU NOEUD
! IN  : NOCMP  : LISTE DES COMPOSANTES A AFFECTER
! IN  : NBCMP  : NOMBRE DE COMPOSANTES A AFFECTER
! IN  : NCMPGD : LISTE GLOBALE DES COMPOSANTES DE LA GRANDEUR
! IN  : NCMPMX : NOMBRE DE COMPOSANTES DE LA GRANDEUR
! IN  : VAL    : VALEURS DES COMPOSANTES A AFFECTER
! IN  : KVAL   : VALEURS DES COMPOSANTES A AFFECTER EN K*8
! OUT : DESC   : DESCRIPTEUR GRANDEUR DU NOEUD
! OUT : VALGLO : TABLEAU DES VALEURS DES COMPOSANTES DE LA GRANDEUR
!
!-----------------------------------------------------------------------
!
    integer :: nocoaf, icmp, j, iec, jj, ind, ior
    integer :: vali(3)
!
    nocoaf = 0
    do 10 icmp = 1, nbcmp
        j = indik8 ( ncmpgd, nocmp(icmp), 1, ncmpmx )
        if (j .ne. 0) then
            iec = ( j - 1 ) / 30 + 1
            jj = j - 30 * ( iec - 1 )
            desc((ino-1)*nec+iec) = ior(desc((ino-1)*nec+iec),2**jj)
        else
            valk = nocmp(icmp)
            call utmess('F', 'CALCULEL5_65', sk=valk)
        endif
        nocoaf = nocoaf + 1
        ind = j + (ino-1)*ncmpmx
        if (type(1:1) .eq. 'R') then
            valglo(ind) = val(icmp)
        else
            kvalgl(ind) = kval(icmp)
        endif
10  end do
!
    if (nocoaf .ne. nbcmp) then
        vali (1) = ioc
        vali (2) = nocoaf
        vali (3) = nbcmp
        call utmess('F', 'CALCULEL5_66', ni=3, vali=vali)
    endif
!
end subroutine
