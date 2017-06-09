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

subroutine mocon2(dir, sigb, siga, hh, nlit,&
                  om, rr, nufsup, nufinf, nufsd1,&
                  nufid1, nufsd2, nufid2, prec)
    implicit none
! person_in_charge: sebastien.fayolle at edf.fr
!
#include "jeveux.h"
!
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lsqpol.h"
#include "asterfort/wkvect.h"
    character(len=8) :: nufsup, nufinf, nufsd1, nufid1, nufsd2, nufid2
    character(len=1) :: dir
    integer :: nlit
    real(kind=8) :: sigb, siga(nlit), hh, om(nlit), rr(nlit), prec, e1, sigma
    integer :: ordlu
    parameter (ordlu=2)
    real(kind=8) :: poly(ordlu+1), xx
    integer :: i, j, npt
    integer :: ordok, jvale, jfon, jprol, jtab, lmax
!
! --- POSITIVE BENDING
    call jeveuo(nufsup//'           .VALE', 'L', jtab)
    call jelira(nufsup//'           .VALE', 'LONMAX', lmax)
!
!--- INTERPOLATION DE LA FONCTION ET CALCUL DES DERIVEES
    e1=0.d0
    npt = lmax/2
    call lsqpol(ordlu, e1, npt, zr(jtab), zr(jtab+npt),&
                ordok, poly, sigma)
!
    call wkvect(nufsd1//'           .VALE', 'G V R', 2*npt, jvale)
    jfon = jvale + npt
    do 74 i = 0, npt-1
        xx = zr(jtab) + (zr(jtab-1+npt)-zr(jtab))*i/(npt-1)
        zr(jvale+i) = xx
        zr(jfon +i) = 0.0d0
        do 75, j = 1,ordok
        zr(jfon +i) = zr(jfon +i) + j*poly(j+1)*(xx**(j-1))
75      continue
74  end do
!
    call wkvect(nufsd2//'           .VALE', 'G V R', 2*npt, jvale)
    jfon = jvale + npt
    do 76 i = 0, npt-1
        xx = zr(jtab) + (zr(jtab-1+npt)-zr(jtab))*i/(npt-1)
        zr(jvale+i) = xx
        zr(jfon +i) = 0.0d0
        do 77, j = 2,ordok-1
        zr(jfon +i) = zr(jfon +i)+ j*(j-1)*poly(j+1)*(xx**(j-2))
77      continue
76  end do
!
!     --- CREATION ET REMPLISSAGE DE L'OBJET NUFSUP.PROL ---
    call jeveuo(nufsup//'           .PROL', 'L', jprol)
    zk24(jprol) = 'FONCTION                '
    zk24(jprol+1) = 'LIN LIN                 '
    zk24(jprol+2) = 'X                       '
    zk24(jprol+3) = 'FME'//dir//'1                   '
    zk24(jprol+4) = 'LL                      '
!
    call wkvect(nufsd1//'           .PROL', 'G V K24', 6, jprol)
    zk24(jprol) = 'FONCTION                '
    zk24(jprol+1) = 'LIN LIN                 '
    zk24(jprol+2) = 'X                       '
    zk24(jprol+3) = 'DFME'//dir//'1                  '
    zk24(jprol+4) = 'CC                      '
!
    call wkvect(nufsd2//'           .PROL', 'G V K24', 6, jprol)
    zk24(jprol) = 'FONCTION                '
    zk24(jprol+1) = 'LIN LIN                 '
    zk24(jprol+2) = 'X                       '
    zk24(jprol+3) = 'DDFME'//dir//'1                 '
    zk24(jprol+4) = 'CC                      '
!
!--- NEGATIVE BENDING
    call jeveuo(nufinf//'           .VALE', 'L', jtab)
    call jelira(nufinf//'           .VALE', 'LONMAX', lmax)
!
!--- INTERPOLATION DE LA FONCTION ET CALCUL DES DERIVEES
    e1=0.d0
    npt = lmax/2
    call lsqpol(ordlu, e1, npt, zr(jtab), zr(jtab+npt),&
                ordok, poly, sigma)
!
    call wkvect(nufid1//'           .VALE', 'G V R', 2*npt, jvale)
    jfon = jvale + npt
    do 104 i = 0, npt-1
        xx = zr(jtab) + (zr(jtab-1+npt)-zr(jtab))*i/(npt-1)
        zr(jvale+i) = xx
        zr(jfon +i) = 0.0d0
        do 105, j = 1,ordok
        zr(jfon +i) = zr(jfon +i) + j*poly(j+1)*(xx**(j-1))
105      continue
104  end do
!
    call wkvect(nufid2//'           .VALE', 'G V R', 2*npt, jvale)
    jfon = jvale + npt
    do 106 i = 0, npt-1
        xx = zr(jtab) + (zr(jtab-1+npt)-zr(jtab))*i/(npt-1)
        zr(jvale+i) = xx
        zr(jfon +i) = 0.0d0
        do 107, j = 2,ordok-1
        zr(jfon +i) = zr(jfon +i)+ j*(j-1)*poly(j+1)*(xx**(j-2))
107      continue
106  end do
!
!     --- CREATION ET REMPLISSAGE DE L'OBJET NUFSUP.PROL ---
    call jeveuo(nufinf//'           .PROL', 'L', jprol)
    zk24(jprol) = 'FONCTION                '
    zk24(jprol+1) = 'LIN LIN                 '
    zk24(jprol+2) = 'X                       '
    zk24(jprol+3) = 'FME'//dir//'2                   '
    zk24(jprol+4) = 'LL                      '
!
    call wkvect(nufid1//'           .PROL', 'G V K24', 6, jprol)
    zk24(jprol) = 'FONCTION                '
    zk24(jprol+1) = 'LIN LIN                 '
    zk24(jprol+2) = 'X                       '
    zk24(jprol+3) = 'DFME'//dir//'2                  '
    zk24(jprol+4) = 'CC                      '
!
    call wkvect(nufid2//'           .PROL', 'G V K24', 6, jprol)
    zk24(jprol) = 'FONCTION                '
    zk24(jprol+1) = 'LIN LIN                 '
    zk24(jprol+2) = 'X                       '
    zk24(jprol+3) = 'DDFME'//dir//'2                 '
    zk24(jprol+4) = 'CC                      '
!
end subroutine
