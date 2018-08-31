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

subroutine rc32s0b(seis, sig, trescamax)
    implicit   none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/rctres.h"
#include "asterfort/jeveuo.h"
    real(kind=8) :: sig(6), trescamax
    real(kind=8) :: seis(6*12)


!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3200
!     CALCUL AVEC TOUTES LES POSSIBILITES DE SIGNE
!     POUR LES CMP DE SEISME
!
!     ------------------------------------------------------------------
!
    integer :: i0, i1, e0(2), i2, i3, i4, i5, i6, i7
    integer :: i8, i9, i10, i11, i12, j, jinfois, typseis
    real(kind=8) :: st(6), tresca

! DEB ------------------------------------------------------------------
!
    trescamax = 0.d0
    do 10 i0 = 1, 2
        i1 = 2*(i0-2)+1
        e0(i0) = i1
10  continue
!
    call jeveuo('&&RC3200.SEIS_INFOI', 'L', jinfois)
    typseis = zi(jinfois+3)
!
    if (typseis .eq. 1) then
!
      do 101 i1 = 1, 2
        do 102 i2 = 1, 2
          do 103 i3 = 1, 2
            do 104 i4 = 1, 2
              do 105 i5 = 1, 2
                do 106 i6 = 1, 2
                  do 107 i7 = 1, 2
                    do 108 i8 = 1, 2
                      do 109 i9 = 1, 2
                        do 110 i10 = 1, 2
                          do 111 i11 = 1, 2
                            do 112 i12 = 1, 2
                              do 113 j = 1, 6
!
                                st(j) =  sig(j)+e0(i1)*seis(j)  +e0(i2)*seis(6+j)  +&
                                               e0(i3)*seis(2*6+j)  +e0(i4)*seis(3*6+j)   +&
                                               e0(i5)*seis(4*6+j)  +e0(i6)*seis(5*6+j)   +&
                                               e0(i7)*seis(6*6+j) +e0(i8)*seis(7*6+j)  +&
                                               e0(i9)*seis(8*6+j) +e0(i10)*seis(9*6+j) +&
                                               e0(i11)*seis(10*6+j)+e0(i12)*seis(11*6+j)
!
113                           continue
                              call rctres(st, tresca)
                              trescamax=max(tresca, trescamax)
112                         continue
111                       continue
110                     continue
109                   continue
108                 continue
107               continue
106             continue
105           continue
104         continue
103       continue
102     continue
101   continue
!
    else
!
      do 201 i1 = 1, 2
        do 202 i2 = 1, 2
          do 203 i3 = 1, 2
            do 204 i4 = 1, 2
              do 205 i5 = 1, 2
                do 206 i6 = 1, 2
                    do 213 j = 1, 6
!
                        st(j) =  sig(j)+e0(i1)*seis(j)+e0(i2)*seis(6+j)+&
                                        e0(i3)*seis(2*6+j)  +e0(i4)*seis(3*6+j)+&
                                        e0(i5)*seis(4*6+j)  +e0(i6)*seis(5*6+j)  
!
213                 continue
                    call rctres(st, tresca)
                    trescamax=max(tresca, trescamax)
!
206             continue
205           continue
204         continue
203       continue
202     continue
201   continue
!
    endif
!
end subroutine
