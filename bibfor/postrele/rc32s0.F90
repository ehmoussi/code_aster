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

subroutine rc32s0(option, sig, lieu, trescamax)
    implicit   none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/rctres.h"
#include "asterfort/jeveuo.h"
#include "asterfort/codent.h"
#include "asterfort/jeexin.h"
#include "asterfort/jexnom.h"
#include "asterfort/utmess.h"
#include "asterfort/getvid.h"
#include "asterfort/rcveri.h"
#include "asterfort/tbexip.h"
#include "asterfort/tbexv1.h"
#include "asterfort/rcver1.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/jedetr.h"
#include "asterfort/tbliva.h"
#include "asterfort/rc32my.h"
    real(kind=8) :: sig(6), trescamax
    character(len=4) :: option, lieu

!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3200
!     CALCUL AVEC TOUTES LES POSSIBILITES DE SIGNE
!     POUR LES CMP DE SEISME
!
!     ------------------------------------------------------------------
!
    integer :: i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12
    integer :: e0(2), jinfois, numcha, jchars, k, jsigu, j, typseis
    integer :: iret, n0, i, nbabsc, jabsc, ibid
    real(kind=8) :: st(6), ms(12), seisfx(6), seisfy(6), seisfz(6)
    real(kind=8) :: seismx(6), seismy(6), seismz(6), seisfx2(6)
    real(kind=8) :: seisfy2(6), seisfz2(6), seismx2(6), seismy2(6)
    real(kind=8) :: seismz2(6), tresca, prec(1), vale(1), momen0
    real(kind=8) :: momen1
    character(len=8) ::  knumec, crit(1), nocmp(6), tabfm(6), k8b
    character(len=16) :: valek(1)
    character(len=24) :: valk(3)
    aster_logical :: exist
    complex(kind=8) :: cbid
    real(kind=8), pointer :: contraintes(:) => null()

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
!-----------------------------------------
!---- le séisme est sous forme unitaire
!-----------------------------------------
      numcha = zi(jinfois+4)
      knumec = 'C       '
      call codent(numcha, 'D0', knumec(2:8))
      call jeexin(jexnom('&&RC3200.VALE_CHAR', knumec), iret)
      if (iret .eq. 0) call utmess('F', 'POSTRCCM_51')
      call jeveuo(jexnom('&&RC3200.VALE_CHAR', knumec), 'L', jchars)
      do 11 k = 1, 12
            ms(k) = zr(jchars-1+k)
11    continue
      call jeveuo('&&RC3200.MECA_UNIT .'//lieu, 'L', jsigu)
!
      if (option .eq. 'SNSN') then 
        do 20 j = 1, 6
          seisfx(j) = 2*ms(1)*zr(jsigu-1+78+j)
          seisfy(j) = 2*ms(2)*zr(jsigu-1+78+1*6+j)
          seisfz(j) = 2*ms(3)*zr(jsigu-1+78+2*6+j)
          seismx(j) = 2*ms(4)*zr(jsigu-1+78+3*6+j)
          seismy(j) = 2*ms(5)*zr(jsigu-1+78+4*6+j)
          seismz(j) = 2*ms(6)*zr(jsigu-1+78+5*6+j)
          seisfx2(j)= 2*ms(7)*zr(jsigu-1+78+6*6+j)
          seisfy2(j)= 2*ms(8)*zr(jsigu-1+78+7*6+j)
          seisfz2(j)= 2*ms(9)*zr(jsigu-1+78+8*6+j)
          seismx2(j)= 2*ms(10)*zr(jsigu-1+78+9*6+j)
          seismy2(j)= 2*ms(11)*zr(jsigu-1+78+10*6+j)
          seismz2(j)= 2*ms(12)*zr(jsigu-1+78+11*6+j)
20      continue
      else if (option .eq. 'SPSP') then 
        do 25 j = 1, 6
          seisfx(j) = 2*ms(1)*zr(jsigu-1+j)
          seisfy(j) = 2*ms(2)*zr(jsigu-1+6*1+j)
          seisfz(j) = 2*ms(3)*zr(jsigu-1+6*2+j)
          seismx(j) = 2*ms(4)*zr(jsigu-1+6*3+j)
          seismy(j) = 2*ms(5)*zr(jsigu-1+6*4+j)
          seismz(j) = 2*ms(6)*zr(jsigu-1+6*5+j)
          seisfx2(j)= 2*ms(7)*zr(jsigu-1+6*6+j)
          seisfy2(j)= 2*ms(8)*zr(jsigu-1+6*7+j)
          seisfz2(j)= 2*ms(9)*zr(jsigu-1+6*8+j)
          seismx2(j)= 2*ms(10)*zr(jsigu-1+6*9+j)
          seismy2(j)= 2*ms(11)*zr(jsigu-1+6*10+j)
          seismz2(j)= 2*ms(12)*zr(jsigu-1+6*11+j)
25      continue
      else if (option .eq. 'PMPM') then 
        do 30 j = 1, 6
          seisfx(j) = 2*ms(1)*zr(jsigu-1+156+j)
          seisfy(j) = 2*ms(2)*zr(jsigu-1+156+6*1+j)
          seisfz(j) = 2*ms(3)*zr(jsigu-1+156+6*2+j)
          seismx(j) = 2*ms(4)*zr(jsigu-1+156+6*3+j)
          seismy(j) = 2*ms(5)*zr(jsigu-1+156+6*4+j)
          seismz(j) = 2*ms(6)*zr(jsigu-1+156+6*5+j)
          seisfx2(j)= 2*ms(7)*zr(jsigu-1+156+6*6+j)
          seisfy2(j)= 2*ms(8)*zr(jsigu-1+156+6*7+j)
          seisfz2(j)= 2*ms(9)*zr(jsigu-1+156+6*8+j)
          seismx2(j)= 2*ms(10)*zr(jsigu-1+156+6*9+j)
          seismy2(j)= 2*ms(11)*zr(jsigu-1+156+6*10+j)
          seismz2(j)= 2*ms(12)*zr(jsigu-1+156+6*11+j)
30      continue
      else if (option .eq. 'PBPB') then 
        do 35 j = 1, 6
          seisfx(j) = 2*ms(1)*zr(jsigu-1+234+j)
          seisfy(j) = 2*ms(2)*zr(jsigu-1+234+6*1+j)
          seisfz(j) = 2*ms(3)*zr(jsigu-1+234+6*2+j)
          seismx(j) = 2*ms(4)*zr(jsigu-1+234+6*3+j)
          seismy(j) = 2*ms(5)*zr(jsigu-1+234+6*4+j)
          seismz(j) = 2*ms(6)*zr(jsigu-1+234+6*5+j)
          seisfx2(j)= 2*ms(7)*zr(jsigu-1+234+6*6+j)
          seisfy2(j)= 2*ms(8)*zr(jsigu-1+234+6*7+j)
          seisfz2(j)= 2*ms(9)*zr(jsigu-1+234+6*8+j)
          seismx2(j)= 2*ms(10)*zr(jsigu-1+234+6*9+j)
          seismy2(j)= 2*ms(11)*zr(jsigu-1+234+6*10+j)
          seismz2(j)= 2*ms(12)*zr(jsigu-1+234+6*11+j)
35      continue
      endif
    else
!-------------------------------------------
!---- le séisme est sous forme de 6 tables
!-------------------------------------------
        valek(1) = 'ABSC_CURV       '
        prec(1) = 1.0d-06
        crit(1) = 'RELATIF'
        nocmp(1) = 'SIXX'
        nocmp(2) = 'SIYY'
        nocmp(3) = 'SIZZ'
        nocmp(4) = 'SIXY'
        nocmp(5) = 'SIXZ'
        nocmp(6) = 'SIYZ'
!-- on récupère les tables correspondantes
        call getvid('SEISME', 'TABL_FX', iocc=1, scal=tabfm(1), nbret=n0)
        call getvid('SEISME', 'TABL_FY', iocc=1, scal=tabfm(2), nbret=n0)
        call getvid('SEISME', 'TABL_FZ', iocc=1, scal=tabfm(3), nbret=n0)
        call getvid('SEISME', 'TABL_MX', iocc=1, scal=tabfm(4), nbret=n0)
        call getvid('SEISME', 'TABL_MY', iocc=1, scal=tabfm(5), nbret=n0)
        call getvid('SEISME', 'TABL_MZ', iocc=1, scal=tabfm(6), nbret=n0)
! ----  on verifie l'ordre des noeuds de la table
        do 36 i = 1, 6
            call rcveri(tabfm(i))
36      continue
! ----- on recupere les abscisses curvilignes de la table
        call tbexip(tabfm(1), valek(1), exist, k8b)
        if (.not. exist) then
            valk (1) = tabfm(1)
            valk (2) = valek(1)
            call utmess('F', 'POSTRCCM_1', nk=2, valk=valk)
        endif
        call tbexv1(tabfm(1), valek(1), 'RC.ABSC', 'V', nbabsc,&
                   k8b)
        call jeveuo('RC.ABSC', 'L', jabsc)
! ----- on vérifie la cohérence des tables
        do 37 i = 1, 5
            call rcver1('MECANIQUE', tabfm(1), tabfm(1+i))
37      continue
!
        AS_ALLOCATE(vr=contraintes,  size=nbabsc)
! ----- on vient lire les tables
        do 40 i = 1, 6
            do 50 j = 1, 6
                do 60 k = 1, nbabsc
                  vale(1) = zr(jabsc+k-1)
!
                  call tbliva(tabfm(i), 1, valek, [ibid], vale,&
                             [cbid], k8b, crit, prec, nocmp(j),&
                             k8b, ibid, contraintes(k), cbid, k8b,&
                             iret)
                  if (iret .ne. 0) then
                    valk (1) = tabfm(i)
                    valk (2) = nocmp(j)
                    valk (3) = valek(1)
                    call utmess('F', 'POSTRCCM_2', nk=3, valk=valk, nr=1,&
                                valr=vale(1))
                  endif
 60             continue
                call rc32my(nbabsc, zr(jabsc), contraintes, momen0, momen1)
                if (option .eq. 'SNSN') then
                  if (lieu .eq. 'ORIG') then
                    if(i .eq. 1) seisfx(j) = 2*(momen0 - 0.5d0*momen1)
                    if(i .eq. 2) seisfy(j) = 2*(momen0 - 0.5d0*momen1)
                    if(i .eq. 3) seisfz(j) = 2*(momen0 - 0.5d0*momen1)
                    if(i .eq. 4) seismx(j) = 2*(momen0 - 0.5d0*momen1)
                    if(i .eq. 5) seismy(j) = 2*(momen0 - 0.5d0*momen1)
                    if(i .eq. 6) seismz(j) = 2*(momen0 - 0.5d0*momen1)
                  else
                    if(i .eq. 1) seisfx(j) = 2*(momen0 + 0.5d0*momen1)
                    if(i .eq. 2) seisfy(j) = 2*(momen0 + 0.5d0*momen1)
                    if(i .eq. 3) seisfz(j) = 2*(momen0 + 0.5d0*momen1)
                    if(i .eq. 4) seismx(j) = 2*(momen0 + 0.5d0*momen1)
                    if(i .eq. 5) seismy(j) = 2*(momen0 + 0.5d0*momen1)
                    if(i .eq. 6) seismz(j) = 2*(momen0 + 0.5d0*momen1)
                  endif
                else if (option .eq. 'SPSP') then
                  if (lieu .eq. 'ORIG') then
                    if(i .eq. 1) seisfx(j) = 2*contraintes(1)
                    if(i .eq. 2) seisfy(j) = 2*contraintes(1)
                    if(i .eq. 3) seisfz(j) = 2*contraintes(1)
                    if(i .eq. 4) seismx(j) = 2*contraintes(1)
                    if(i .eq. 5) seismy(j) = 2*contraintes(1)
                    if(i .eq. 6) seismz(j) = 2*contraintes(1)
                  else
                    if(i .eq. 1) seisfx(j) = 2*contraintes(nbabsc)
                    if(i .eq. 2) seisfy(j) = 2*contraintes(nbabsc)
                    if(i .eq. 3) seisfz(j) = 2*contraintes(nbabsc)
                    if(i .eq. 4) seismx(j) = 2*contraintes(nbabsc)
                    if(i .eq. 5) seismy(j) = 2*contraintes(nbabsc)
                    if(i .eq. 6) seismz(j) = 2*contraintes(nbabsc)
                  endif
                else if (option .eq. 'PMPM') then
                    if(i .eq. 1) seisfx(j) = 2*momen0 
                    if(i .eq. 2) seisfy(j) = 2*momen0 
                    if(i .eq. 3) seisfz(j) = 2*momen0 
                    if(i .eq. 4) seismx(j) = 2*momen0 
                    if(i .eq. 5) seismy(j) = 2*momen0 
                    if(i .eq. 6) seismz(j) = 2*momen0 
                else if (option .eq. 'PBPB') then
                    if(i .eq. 1) seisfx(j) = 2*(0.5d0*momen1) 
                    if(i .eq. 2) seisfy(j) = 2*(0.5d0*momen1)  
                    if(i .eq. 3) seisfz(j) = 2*(0.5d0*momen1) 
                    if(i .eq. 4) seismx(j) = 2*(0.5d0*momen1) 
                    if(i .eq. 5) seismy(j) = 2*(0.5d0*momen1) 
                    if(i .eq. 6) seismz(j) = 2*(0.5d0*momen1) 
                endif
 50         continue
 40     continue
!
        do 70 j = 1, 6
            seisfx2(j)= 0.d0
            seisfy2(j)= 0.d0
            seisfz2(j)= 0.d0
            seismx2(j)= 0.d0
            seismy2(j)= 0.d0
            seismz2(j)= 0.d0
70      continue
        call jedetr('RC.ABSC')
        AS_DEALLOCATE(vr=contraintes)
    endif
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
                                st(j) =  sig(j)+e0(i1)*seisfx(j)  +e0(i2)*seisfy(j)  +&
                                               e0(i3)*seisfz(j)  +e0(i4)*seismx(j)   +&
                                               e0(i5)*seismy(j)  +e0(i6)*seismz(j)   +&
                                               e0(i7)*seisfx2(j) +e0(i8)*seisfy2(j)  +&
                                               e0(i9)*seisfz2(j) +e0(i10)*seismx2(j) +&
                                               e0(i11)*seismy2(j)+e0(i12)*seismz2(j)
!
113                         continue
                            call rctres(st, tresca)
                            trescamax=max(tresca, trescamax)
112                       continue
111                     continue
110                   continue
109                 continue
108               continue
107             continue
106           continue
105         continue
104       continue
103     continue
102   continue
101 continue
!
end subroutine
