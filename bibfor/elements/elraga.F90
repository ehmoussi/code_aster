! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! aslint: disable=W1501
!
subroutine elraga(elrefz, fapz, ndim, nbpg, coopg,&
                  poipg)
!
implicit none
!
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/elraca.h"
!
character(len=*), intent(in) :: elrefz, fapz
integer, intent(out) :: nbpg, ndim
real(kind=8), intent(out) :: coopg(*), poipg(*)
!
! --------------------------------------------------------------------------------------------------
!
! Finite elements management
!
! Get parameters of geometric support for finite element
!
! --------------------------------------------------------------------------------------------------
!
! In  elrefe           : name of geometric support for finite element
! In  fapg             : name of Gauss integration scheme
! Out ndim             : topological dimension (0/1/2/3)
! Out nbpg             : number of points of integration schemes
! Out coopg            : coordinataes of Gauss points
! Out poipg            : weight of Gauss points
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nbpgmx = 1000
    integer, parameter :: nbfamx = 20
    character(len=8) :: elrefa, fapg, nofpg(nbfamx)
    integer :: i, npar, npi, ix, iy, iz, npx, npyz
    integer :: nno, nnos, nbfpg, nbpg1(nbfamx), ino, ifam
    real(kind=8) :: xpg(nbpgmx), ypg(nbpgmx), zpg(nbpgmx), hpg(nbpgmx), a(4)
    real(kind=8) :: h(4)
    real(kind=8) :: aty(7), ht(7), atz(7)
    real(kind=8) :: aa, bb, cc, hh, h1, h2, h3, rac5, rac15, a1, b1, b6, c1, c8
    real(kind=8) :: d1, d12
    real(kind=8) :: p1, p2, p3, p4, p5
    real(kind=8) :: xa, xb
    real(kind=8) :: zero, unquar, undemi, un, deux, xno(3*27), vol, a2, b2
    real(kind=8) :: untiers
#define t(u) 2.0d0*(u) - 1.0d0
!
! --------------------------------------------------------------------------------------------------
!
    elrefa = elrefz
    fapg = fapz
    zero = 0.0d0
    unquar = 0.25d0
    undemi = 0.5d0
    un = 1.0d0
    deux = 2.0d0
    untiers = 1.d0/3.d0
    rac5 = sqrt(5.d0)
!
!     -- CALCUL DE NBPG,NDIM,VOL,NNO,XNO :
!     ------------------------------------
    call elraca(elrefa, ndim, nno, nnos, nbfpg,&
                nofpg, nbpg1, xno, vol)
    ifam = indik8(nofpg,fapg,1,nbfpg)
    ASSERT(ifam .gt. 0)
    nbpg = nbpg1(ifam)
    ASSERT((ndim.ge.0).and.(ndim.le.3))
!
!
!     -- TRAITEMENT GENERIQUE DE FAPG='NOEU' :
!     -----------------------------------------
    if (fapg .eq. 'NOEU') then
        ASSERT(nbpg.eq.nno)
        do ino = 1,nno
            hpg(ino) = vol/nno
            if (ndim .ge. 1) xpg(ino) = xno(ndim* (ino-1)+1)
            if (ndim .ge. 2) ypg(ino) = xno(ndim* (ino-1)+2)
            if (ndim .eq. 3) zpg(ino) = xno(ndim* (ino-1)+3)
        end do
        goto 170
    endif
!
!
!     -- TRAITEMENT GENERIQUE DE FAPG='NOEU_S' :
!     -----------------------------------------
    if (fapg .eq. 'NOEU_S') then
        ASSERT(nbpg.eq.nnos)
        do ino = 1,nnos
            hpg(ino) = vol/nnos
            if (ndim .ge. 1) xpg(ino) = xno(ndim* (ino-1)+1)
            if (ndim .ge. 2) ypg(ino) = xno(ndim* (ino-1)+2)
            if (ndim .eq. 3) zpg(ino) = xno(ndim* (ino-1)+3)
        end do
        goto 170
    endif
!
!
!     -- TRAITEMENT GENERIQUE DE FAPG='FPG1' :
!     -----------------------------------------
    if (fapg .eq. 'FPG1') then
        ASSERT(nbpg.eq.1)
        xpg(1) = 0.d0
        if (ndim .ge. 1) xpg(1) = 0.d0
        if (ndim .ge. 2) ypg(1) = 0.d0
        if (ndim .eq. 3) zpg(1) = 0.d0
        do ino = 1,nno
            if (ndim .ge. 1) xpg(1) = xpg(1) + xno(ndim* (ino-1)+1)
            if (ndim .ge. 2) ypg(1) = ypg(1) + xno(ndim* (ino-1)+2)
            if (ndim .eq. 3) zpg(1) = zpg(1) + xno(ndim* (ino-1)+3)
        end do
        if (ndim .ge. 1) xpg(1) = xpg(1)/nno
        if (ndim .ge. 2) ypg(1) = ypg(1)/nno
        if (ndim .eq. 3) zpg(1) = zpg(1)/nno
        hpg(1) = vol
        goto 170
    endif
!
!
!     ------------------------------------------------------------------
    if (elrefa .eq. 'HE8' .or. elrefa .eq. 'H20' .or. elrefa .eq. 'H27') then
!
        npar = 0
!
        if (fapg .eq. 'FPG1') then
! --------- FORMULE DE QUADRATURE DE GAUSS A 1 POINTS ( ORDRE 1 )
            xpg(1) = zero
            ypg(1) = zero
            zpg(1) = zero
            hpg(1) = 8.d0
        else if (fapg .eq. 'FPG8') then
! --------- FORMULE DE QUADRATURE DE GAUSS A 2 POINTS DANS CHAQUE
!           DIRECTION ( ORDRE 3 )
            npar = 2
            a(1) = -0.577350269189626d0
            a(2) = -a(1)
            h(1) = un
            h(2) = un
!
        else if (fapg.eq.'FPG27') then
! --------- FORMULE DE QUADRATURE DE GAUSS A 3 POINTS DANS CHAQUE
!           DIRECTION ( ORDRE 5 )
            npar = 3
            a(1) = -0.774596669241483d0
            a(2) = zero
            a(3) = -a(1)
            h(1) = 0.555555555555556d0
            h(2) = 0.888888888888889d0
            h(3) = h(1)
        else if (fapg.eq.'FPG64') then
! --------- FORMULE DE QUADRATURE DE GAUSS A 4 POINTS DANS CHAQUE
!           DIRECTION ( ORDRE 7 )
            npar = 4
            a(1) = -0.339981043584856d0
            a(2) = -a(1)
            a(3) = -0.861136311594052d0
            a(4) = -a(3)
            h(1) = 0.652145154862546d0
            h(2) = h(1)
            h(3) = 0.347854845137453d0
            h(4) = h(3)
!
        else if (fapg.eq.'FPG8NOS') then
! ------- POUR LES POINTS DE GAUSS -------------------------------------
            npar = 2
            a(1) = -0.577350269189626d0
            a(2) = -a(1)
            h(1) = un
            h(2) = un
! ------- POUR LES SOMMETS ---------------------------------------------
            do ino = 1,nnos
                hpg(ino+8) = vol/nnos
                xpg(ino+8) = xno(ndim* (ino-1)+1)
                if (ndim .ge. 2) ypg(ino+8) = xno(ndim* (ino-1)+2)
                if (ndim .eq. 3) zpg(ino+8) = xno(ndim* (ino-1)+3)
            end do
!
        else
            ASSERT(ASTER_FALSE)
        endif
!
!       TRAITEMENT POUR FAPG
        npi = 0
        do ix = 1, npar
            do iy = 1, npar
                do iz = 1, npar
                    npi = npi + 1
                    xpg(npi) = a(ix)
                    ypg(npi) = a(iy)
                    zpg(npi) = a(iz)
                    hpg(npi) = h(ix)*h(iy)*h(iz)
                end do
            end do
        end do

!     ------------------------------------------------------------------
    else if (elrefa.eq.'PE6' .or. elrefa.eq.'P15' .or. elrefa.eq.'P18') then
!
        if (fapg .eq. 'FPG6') then
            npx = 2
            npyz = 3
            a(1) = -0.577350269189626d0
            a(2) = -a(1)
            aty(1) = undemi
            aty(2) = zero
            aty(3) = undemi
            atz(1) = undemi
            atz(2) = undemi
            atz(3) = zero
            h(1) = un
            h(2) = un
            ht(1) = un/6.d0
            ht(2) = ht(1)
            ht(3) = ht(1)
!
        else if (fapg.eq.'FPG6B') then
            npx = 2
            npyz = 3
            a(1) = -0.577350269189626d0
            a(2) = -a(1)
            aty(1) = 1.d0/6.d0
            aty(2) = 2.d0/3.d0
            aty(3) = 1.d0/6.d0
            atz(1) = 1.d0/6.d0
            atz(2) = 1.d0/6.d0
            atz(3) = 2.d0/3.d0
            h(1) = un
            h(2) = un
            ht(1) = 1.d0/6.d0
            ht(2) = ht(1)
            ht(3) = ht(1)
!
        else if (fapg.eq.'FPG8') then
!
! --------- FORMULE A 4 * 2 POINTS :  (CF TOUZOT PAGE 297)
!                   2 POINTS DE GAUSS  EN X   (ORDRE 3)
!                   4 POINTS DE HAMMER EN Y Z (ORDRE 3 EN Y Z)
!
! --------- FORMULE DE GAUSS
!
            npx = 2
            a(1) = -0.577350269189626d0
            a(2) = -a(1)
            h(1) = un
            h(2) = un
!
! --------- FORMULE DE HAMMER
!
            npyz = 4
            aty(1) = 0.333333333333333d0
            aty(2) = 0.6d0
            aty(3) = 0.2d0
            aty(4) = 0.2d0
            atz(1) = 0.333333333333333d0
            atz(2) = 0.2d0
            atz(3) = 0.6d0
            atz(4) = 0.2d0
            ht(1) = -27.d0/96.d0
            ht(2) = 25.d0/96.d0
            ht(3) = ht(2)
            ht(4) = ht(2)
!
        else if (fapg.eq.'FPG21') then
!
! --------- FORMULE A 7 * 3 POINTS :   (CF TOUZOT PAGE 298)
!                   3 POINTS DE GAUSS EN X (ORDRE 5)
!                   7 POINTS DE HAMMER EN Y Z (ORDRE 5 EN Y Z)
!
! --------- FORMULE DE GAUSS
!
            npx = 3
            a(1) = -0.774596669241483d0
            a(2) = zero
            a(3) = -a(1)
            h(1) = 0.555555555555556d0
            h(2) = 0.888888888888889d0
            h(3) = h(1)
!
! --------- FORMULE DE HAMMER
!
            npyz = 7
            aty(1) = 0.333333333333333d0
            atz(1) = 0.333333333333333d0
            aty(2) = 0.470142064105115d0
            atz(2) = 0.470142064105115d0
            aty(3) = un - deux*aty(2)
            atz(3) = 0.470142064105115d0
            aty(4) = 0.470142064105115d0
            atz(4) = un - deux*aty(2)
            aty(5) = 0.101286507323456d0
            atz(5) = 0.101286507323456d0
            aty(6) = un - deux*aty(5)
            atz(6) = 0.101286507323456d0
            aty(7) = 0.101286507323456d0
            atz(7) = un - deux*aty(5)
            ht(1) = 9.d0/80.d0
            ht(2) = 0.0661970763942530d0
            ht(3) = ht(2)
            ht(4) = ht(2)
            ht(5) = 0.0629695902724135d0
            ht(6) = ht(5)
            ht(7) = ht(5)
!
        else if (fapg.eq.'FPG6NOS') then
! ------- POUR LES POINTS DE GAUSS -------------------------------------
            npx = 2
            npyz = 3
            a(1) = -0.577350269189626d0
            a(2) = 0.577350269189626d0
            aty(1) = undemi
            aty(2) = zero
            aty(3) = undemi
            atz(1) = undemi
            atz(2) = undemi
            atz(3) = zero
            h(1) = un
            h(2) = un
            ht(1) = 0.166666666666667d0
            ht(2) = ht(1)
            ht(3) = ht(1)
!
! ------- POUR LES SOMMETS ---------------------------------------------
            do ino = 1,nnos
                hpg(ino+6) = vol/nnos
                xpg(ino+6) = xno(ndim* (ino-1)+1)
                if (ndim .ge. 2) ypg(ino+6) = xno(ndim* (ino-1)+2)
                if (ndim .eq. 3) zpg(ino+6) = xno(ndim* (ino-1)+3)
            end do
!
        else
            ASSERT(ASTER_FALSE)
        endif
!
!       TRAITEMENT POUR LES FAPG
        npi = 0
        do ix = 1, npx
            do iy = 1, npyz
                npi = npi + 1
                xpg(npi) = a(ix)
                ypg(npi) = aty(iy)
                zpg(npi) = atz(iy)
                hpg(npi) = h(ix)*ht(iy)
            end do
        end do
!
!     ------------------------------------------------------------------
    else if (elrefa.eq.'TE4' .or. elrefa.eq.'TE9' .or. elrefa.eq.'T10') then
!
        if (fapg .eq. 'FPG4') then
!
! --------- FORMULE A 4 POINTS :  (CF TOUZOT PAGE 300)
!                   ORDRE 2 EN X Y Z
!
            aa = (5.d0-rac5)/20.d0
            bb = (5.d0+3.d0*rac5)/20.d0
            hh = un/24.d0
            npi = 0
            do i = 1, 4
                npi = npi + 1
                xpg(npi) = aa
                ypg(npi) = aa
                zpg(npi) = aa
                hpg(npi) = hh
            end do
            zpg(2) = bb
            ypg(3) = bb
            xpg(4) = bb
!
        else if (fapg.eq.'FPG5') then
!
! --------- FORMULE A 5 POINTS :  (CF TOUZOT PAGE 300)
!                   ORDRE 3 EN X Y Z
!
            aa = 0.25d0
            bb = un/6.d0
            cc = undemi
            h1 = -deux/15.d0
            h2 = 3.d0/40.d0
            xpg(1) = aa
            ypg(1) = aa
            zpg(1) = aa
            hpg(1) = h1
            do i = 2, 5
                xpg(i) = bb
                ypg(i) = bb
                zpg(i) = bb
                hpg(i) = h2
            end do
            zpg(3) = cc
            ypg(4) = cc
            xpg(5) = cc
!
        else if (fapg.eq.'FPG11') then
!
! --------- FORMULE A 11 POINTS :  (CF DUNAVANT)
!                   ORDRE 4 EN X Y Z
            xpg(1) = 0.097204644587583d0
            ypg(1) = 0.106604172561993d0
            zpg(1) = 0.684390415453040d0
            hpg(1) = 0.106468034155490d0 / 6.d0
!
            xpg(2) = 0.029569495206479d0
            ypg(2) = 0.329232959742646d0
            zpg(2) = 0.317903560213394d0
            hpg(2) = 0.110234232428497d0 / 6.d0
!
            xpg(3) = 0.432710239047768d0
            ypg(3) = 0.103844116410993d0
            zpg(3) = 0.353823239209297d0
            hpg(3) = 0.154976116016246d0 / 6.d0
!
            xpg(4) = 0.240276664928072d0
            ypg(4) = 0.304448402434496d0
            zpg(4) = 0.126801725915392d0
            hpg(4) = 0.193410812049634d0 / 6.d0
!
            xpg(5) = 0.129411373788910d0
            ypg(5) = 0.538007203916185d0
            zpg(5) = 0.330190414837464d0
            hpg(5) = 0.076162715245558d0 / 6.d0
!
            xpg(6) = 0.121541991333927d0
            ypg(6) = 0.008991260093335d0
            zpg(6) = 0.306493988429690d0
            hpg(6) = 0.079426680068025d0 / 6.d0
!
            xpg(7) = 0.450765876091276d0
            ypg(7) = 0.432953490481355d0
            zpg(7) = 0.059456616299433d0
            hpg(7) = 0.069469965937635d0 / 6.d0
!
            xpg(8) = 0.419266313879513d0
            ypg(8) = 0.053341239535745d0
            zpg(8) = 0.047781435559086d0
            hpg(8) = 0.059933185146559d0 / 6.d0
!
            xpg(9) = 0.067223294893383d0
            ypg(9) = 0.741228882093622d0
            zpg(9) = 0.035183929773598d0
            hpg(9) = 0.055393798871576d0 / 6.d0
!
            xpg(10) = 0.752508507009654d0
            ypg(10) = 0.081404918402859d0
            zpg(10) = 0.068099370938206d0
            hpg(10) = 0.055273369155936d0 / 6.d0
!
            xpg(11) = 0.040490506727590d0
            ypg(11) = 0.174694058697230d0
            zpg(11) = 0.013560701879802d0
            hpg(11) = 0.039251090924839d0 / 6.d0
!
        else if (fapg.eq.'FPG15') then
!
! --------- FORMULE A 15 POINTS :  (CF TOUZOT PAGE 300)
!                   ORDRE 5 EN X Y Z
!
            rac15 = sqrt(15.0d0)
            xpg(1) = 0.25d0
            ypg(1) = 0.25d0
            zpg(1) = 0.25d0
            hpg(1) = 8.0d0/405.0d0
!
            xpg(2) = (7.0d0+rac15)/34.0d0
            ypg(2) = xpg(2)
            zpg(2) = xpg(2)
            hpg(2) = (2665.0d0-14.0d0*rac15)/226800.0d0
            xpg(3) = xpg(2)
            ypg(3) = xpg(2)
            zpg(3) = (13.0d0-3.0d0*rac15)/34.0d0
            hpg(3) = hpg(2)
            xpg(4) = xpg(2)
            ypg(4) = (13.0d0-3.0d0*rac15)/34.0d0
            zpg(4) = xpg(2)
            hpg(4) = hpg(2)
            xpg(5) = (13.0d0-3.0d0*rac15)/34.0d0
            ypg(5) = xpg(2)
            zpg(5) = xpg(2)
            hpg(5) = hpg(2)
!
            xpg(6) = (7.0d0-rac15)/34.0d0
            ypg(6) = xpg(6)
            zpg(6) = xpg(6)
            hpg(6) = (2665.0d0+14.0d0*rac15)/226800.0d0
            xpg(7) = xpg(6)
            ypg(7) = xpg(6)
            zpg(7) = (13.0d0+3.0d0*rac15)/34.0d0
            hpg(7) = hpg(6)
            xpg(8) = xpg(6)
            ypg(8) = (13.0d0+3.0d0*rac15)/34.0d0
            zpg(8) = xpg(6)
            hpg(8) = hpg(6)
            xpg(9) = (13.0d0+3.0d0*rac15)/34.0d0
            ypg(9) = xpg(6)
            zpg(9) = xpg(6)
            hpg(9) = hpg(6)
!
            xpg(10) = (5.0d0-rac15)/20.0d0
            ypg(10) = xpg(10)
            zpg(10) = (5.0d0+rac15)/20.0d0
            hpg(10) = 5.0d0/567.0d0
            xpg(11) = xpg(10)
            ypg(11) = (5.0d0+rac15)/20.0d0
            zpg(11) = xpg(10)
            hpg(11) = 5.0d0/567.0d0
            xpg(12) = (5.0d0+rac15)/20.0d0
            ypg(12) = xpg(10)
            zpg(12) = xpg(10)
            hpg(12) = 5.0d0/567.0d0
!
            xpg(13) = xpg(10)
            ypg(13) = (5.0d0+rac15)/20.0d0
            zpg(13) = ypg(13)
            hpg(13) = 5.0d0/567.0d0
            xpg(14) = ypg(13)
            ypg(14) = xpg(10)
            zpg(14) = ypg(13)
            hpg(14) = 5.0d0/567.0d0
            xpg(15) = ypg(13)
            ypg(15) = ypg(13)
            zpg(15) = xpg(10)
            hpg(15) = 5.0d0/567.0d0
!
        else if (fapg.eq.'FPG23') then
!
! --------- FORMULE A 23 POINTS :  (CF DUNAVANT)
!                   ORDRE 6 EN X Y Z
            xpg(1) = 0.038836084344884d0
            ypg(1) = 0.024318974248143d0
            zpg(1) = 0.902928799013611d0
            hpg(1) = 0.001182632475277d0
!
            xpg(2) = 0.064769436930053d0
            ypg(2) = 0.267844198183576d0
            zpg(2) = 0.636767508558514d0
            hpg(2) = 0.005251568313784d0
!
            xpg(3) = 0.064775160447105d0
            ypg(3) = 0.023467795573055d0
            zpg(3) = 0.390862050671012d0
            hpg(3) = 0.004038547812907d0
!
            xpg(4) = 0.277903669330078d0
            ypg(4) = 0.063732895294998d0
            zpg(4) = 0.594909689021796d0
            hpg(4) = 0.008148345983740d0
!
            xpg(5) = 0.066098662414680d0
            ypg(5) = 0.083678814060055d0
            zpg(5) = 0.630054555110990d0
            hpg(5) = 0.008838887318028d0
!
            xpg(6) = 0.325119658577025d0
            ypg(6) = 0.329379718549198d0
            zpg(6) = 0.326833504619046d0
            hpg(6) = 0.007206549449246d0
!
            xpg(7) = 0.319194280348931d0
            ypg(7) = 0.304169265349782d0
            zpg(7) = 0.044383344357208d0
            hpg(7) = 0.011189302702093d0
!
            xpg(8) = 0.328388171231222d0
            ypg(8) = 0.038288670738245d0
            zpg(8) = 0.320287433697693d0
            hpg(8) = 0.009970224610238d0
!
            xpg(9) = 0.055099022490726d0
            ypg(9) = 0.351939197334705d0
            zpg(9) = 0.381084308906310d0
            hpg(9) = 0.010435745880219d0
!
            xpg(10) = 0.124649963637486d0
            ypg(10) = 0.152103811309931d0
            zpg(10) = 0.201234567364421d0
            hpg(10) = 0.010722336995515d0
!
            xpg(11) = 0.065924923160010d0
            ypg(11) = 0.624321363553430d0
            zpg(11) = 0.253593674743200d0
            hpg(11) = 0.007265066343438d0
!
            xpg(12) = 0.007354523838069d0
            ypg(12) = 0.211297658581586d0
            zpg(12) = 0.251184495277530d0
            hpg(12) = 0.003760944546357d0
!
            xpg(13) = 0.617455720147269d0
            ypg(13) = 0.063199980942570d0
            zpg(13) = 0.258449148983926d0
            hpg(13) = 0.007768855687763d0
!
            xpg(14) = 0.279420052945988d0
            ypg(14) = 0.255820784264986d0
            zpg(14) = 0.269569929633272d0
            hpg(14) = 0.018766567415678d0
!
            xpg(15) = 0.287725094826464d0
            ypg(15) = 0.577345781389727d0
            zpg(15) = 0.064620638073369d0
            hpg(15) = 0.008989168438052d0
!
            xpg(16) = 0.594717301875796d0
            ypg(16) = 0.065177992763370d0
            zpg(16) = 0.066603298007603d0
            hpg(16) = 0.008294771681919d0
!
            xpg(17) = 0.066789599781738d0
            ypg(17) = 0.530063275481017d0
            zpg(17) = 0.076992717100967d0
            hpg(17) = 0.010511060314253d0
!
            xpg(18) = 0.626540201708882d0
            ypg(18) = 0.248449540118895d0
            zpg(18) = 0.062115533183599d0
            hpg(18) = 0.007858005078710d0
!
            xpg(19) = 0.060010583020269d0
            ypg(19) = 0.213041183236186d0
            zpg(19) = 0.025842686260703d0
            hpg(19) = 0.004250720711174d0
!
            xpg(20) = 0.275786300469851d0
            ypg(20) = 0.053996140835915d0
            zpg(20) = 0.060016149166169d0
            hpg(20) = 0.006619016274847d0
!
            xpg(21) = 0.051325206165203d0
            ypg(21) = 0.841138951662319d0
            zpg(21) = 0.037264752138356d0
            hpg(21) = 0.002654246530834d0
!
            xpg(22) = 0.040576051066818d0
            ypg(22) = 0.008781957777519d0
            zpg(22) = 0.088600350468910d0
            hpg(22) = 0.001737222620616d0
!
            xpg(23) = 0.903770001332182d0
            ypg(23) = 0.022865823814023d0
            zpg(23) = 0.029335721083179d0
            hpg(23) = 0.001206879481978d0
!
        else if (fapg.eq.'FPG4NOS') then
! ------- POUR LES POINTS DE GAUSS -------------------------------------
            aa = (5.d0-rac5)/20.d0
            bb = (5.d0+3.d0*rac5)/20.d0
            hh = un/24.d0
            npi = 0
            do i = 1, 4
                npi = npi + 1
                xpg(npi) = aa
                ypg(npi) = aa
                zpg(npi) = aa
                hpg(npi) = hh
            end do
            zpg(2) = bb
            ypg(3) = bb
            xpg(4) = bb
! ------- POUR LES SOMMETS ---------------------------------------------
            do ino = 1,nnos
                hpg(ino+4) = vol/nnos
                xpg(ino+4) = xno(ndim* (ino-1)+1)
                if (ndim .ge. 2) ypg(ino+4) = xno(ndim* (ino-1)+2)
                if (ndim .eq. 3) zpg(ino+4) = xno(ndim* (ino-1)+3)
            end do
        endif
!
!     ------------------------------------------------------------------
    else if (elrefa.eq.'PY5' .or. elrefa.eq.'P13') then
!
        if (fapg .eq. 'FPG5') then
!
            p1 = 0.1333333333333333d0
            h1 = 0.1531754163448146d0
            h2 = 0.6372983346207416d0
!
            xpg(1) = undemi
            xpg(2) = zero
            xpg(3) = -undemi
            xpg(4) = zero
            xpg(5) = zero
!
            ypg(1) = zero
            ypg(2) = undemi
            ypg(3) = zero
            ypg(4) = -undemi
            ypg(5) = zero
!
            zpg(1) = h1
            zpg(2) = h1
            zpg(3) = h1
            zpg(4) = h1
            zpg(5) = h2
!
            hpg(1) = p1
            hpg(2) = p1
            hpg(3) = p1
            hpg(4) = p1
            hpg(5) = p1
!
        else if (fapg.eq.'FPG6') then
!
            p1 = 0.1024890634400000d0
            p2 = 0.1100000000000000d0
            p3 = 0.1467104129066667d0
!
            aa = 0.5702963741068025d0
            h1 = 0.1666666666666667d0
            h2 = 0.8063183038464675d-1
            h3 = 0.6098484849057127d0
!
            xpg(1) = aa
            xpg(2) = zero
            xpg(3) = -aa
            xpg(4) = zero
            xpg(5) = zero
            xpg(6) = zero
!
            ypg(1) = zero
            ypg(2) = aa
            ypg(3) = zero
            ypg(4) = -aa
            ypg(5) = zero
            ypg(6) = zero
!
            zpg(1) = h1
            zpg(2) = h1
            zpg(3) = h1
            zpg(4) = h1
            zpg(5) = h2
            zpg(6) = h3
!
            hpg(1) = p1
            hpg(2) = p1
            hpg(3) = p1
            hpg(4) = p1
            hpg(5) = p2
            hpg(6) = p3
!
! --- POUR L'INSTANT L'INTEGRATION AVEC 27 POINTS N'EST PAS UTLISEE
!     -------------------------------------------------------------
        else if (fapg.eq.'FPG27') then
!
            a1 = 0.788073483d0
            b6 = 0.499369002d0
            b1 = 0.848418011d0
            c8 = 0.478508449d0
            c1 = 0.652816472d0
            d12 = 0.032303742d0
            d1 = 1.106412899d0
!
            zpg(1) = undemi
            zpg(2) = undemi
            zpg(3) = undemi
            zpg(4) = undemi
            zpg(5) = undemi
            zpg(6) = undemi* (un-b1)
            zpg(7) = undemi* (un+b1)
            zpg(8) = undemi* (un-c1)
            zpg(9) = undemi* (un-c1)
            zpg(10) = undemi* (un-c1)
            zpg(11) = undemi* (un-c1)
            zpg(12) = undemi* (un+c1)
            zpg(13) = undemi* (un+c1)
            zpg(14) = undemi* (un+c1)
            zpg(15) = undemi* (un+c1)
            zpg(16) = undemi* (un-d1)
            zpg(17) = undemi* (un-d1)
            zpg(18) = undemi* (un-d1)
            zpg(19) = undemi* (un-d1)
            zpg(20) = undemi
            zpg(21) = undemi
            zpg(22) = undemi
            zpg(23) = undemi
            zpg(24) = undemi* (un+d1)
            zpg(25) = undemi* (un+d1)
            zpg(26) = undemi* (un+d1)
            zpg(27) = undemi* (un+d1)
!
            xpg(1) = zero
            xpg(2) = undemi*b1* (un-zpg(2))
            xpg(3) = -undemi*b1* (un-zpg(3))
            xpg(4) = -undemi*b1* (un-zpg(4))
            xpg(5) = undemi*b1* (un-zpg(5))
            xpg(6) = zero
            xpg(7) = zero
            xpg(8) = c1* (un-zpg(8))
            xpg(9) = zero
            xpg(10) = -c1* (un-zpg(10))
            xpg(11) = zero
            xpg(12) = c1* (un-zpg(12))
            xpg(13) = zero
            xpg(14) = -c1* (un-zpg(14))
            xpg(15) = zero
            xpg(16) = undemi*d1* (un-zpg(16))
            xpg(17) = -undemi*d1* (un-zpg(17))
            xpg(18) = -undemi*d1* (un-zpg(18))
            xpg(19) = undemi*d1* (un-zpg(19))
            xpg(20) = d1* (un-zpg(20))
            xpg(21) = zero
            xpg(22) = -d1* (un-zpg(22))
            xpg(23) = zero
            xpg(24) = undemi*d1* (un-zpg(24))
            xpg(25) = -undemi*d1* (un-zpg(25))
            xpg(26) = -undemi*d1* (un-zpg(26))
            xpg(27) = undemi*d1* (un-zpg(27))
!
            ypg(1) = zero
            ypg(2) = xpg(2)
            ypg(3) = -xpg(3)
            ypg(4) = xpg(4)
            ypg(5) = -xpg(5)
            ypg(6) = xpg(6)
            ypg(7) = xpg(7)
            ypg(8) = zero
            ypg(9) = c1* (un-zpg(9))
            ypg(10) = zero
            ypg(11) = -c1* (un-zpg(11))
            ypg(12) = zero
            ypg(13) = c1* (un-zpg(13))
            ypg(14) = zero
            ypg(15) = -c1* (un-zpg(15))
            ypg(16) = xpg(16)
            ypg(17) = -xpg(17)
            ypg(18) = xpg(18)
            ypg(19) = -xpg(19)
            ypg(20) = zero
            ypg(21) = d1* (un-zpg(21))
            ypg(22) = zero
            ypg(23) = -d1* (un-zpg(23))
            ypg(24) = xpg(24)
            ypg(25) = -xpg(25)
            ypg(26) = xpg(26)
            ypg(27) = -xpg(27)
!
            hpg(1) = a1
            hpg(2) = b6
            hpg(3) = b6
            hpg(4) = b6
            hpg(5) = b6
            hpg(6) = b6
            hpg(7) = b6
            hpg(8) = c8
            hpg(9) = c8
            hpg(10) = c8
            hpg(11) = c8
            hpg(12) = c8
            hpg(13) = c8
            hpg(14) = c8
            hpg(15) = c8
            hpg(16) = d12
            hpg(17) = d12
            hpg(18) = d12
            hpg(19) = d12
            hpg(20) = d12
            hpg(21) = d12
            hpg(22) = d12
            hpg(23) = d12
            hpg(24) = d12
            hpg(25) = d12
            hpg(26) = d12
            hpg(27) = d12
!
            do i = 1, 27
                hpg(i) = hpg(i)*unquar* (un-zpg(i))* (un-zpg(i))
            end do
!
        else if (fapg.eq.'FPG5NOS') then
! ------- POUR LES POINTS DE GAUSS -------------------------------------
            p1 = 0.1333333333333333d0
            h1 = 0.1531754163448146d0
            h2 = 0.6372983346207416d0
!
            xpg(1) = undemi
            xpg(2) = zero
            xpg(3) = -undemi
            xpg(4) = zero
            xpg(5) = zero
!
            ypg(1) = zero
            ypg(2) = undemi
            ypg(3) = zero
            ypg(4) = -undemi
            ypg(5) = zero
!
            zpg(1) = h1
            zpg(2) = h1
            zpg(3) = h1
            zpg(4) = h1
            zpg(5) = h2
!
            hpg(1) = p1
            hpg(2) = p1
            hpg(3) = p1
            hpg(4) = p1
            hpg(5) = p1
! --- POUR LES SOMMETS -------------------------------------------------
            do ino = 1,nnos
                hpg(ino+5) = vol/nnos
                xpg(ino+5) = xno(ndim* (ino-1)+1)
                if (ndim .ge. 2) ypg(ino+5) = xno(ndim* (ino-1)+2)
                if (ndim .eq. 3) zpg(ino+5) = xno(ndim* (ino-1)+3)
            end do
        else
            ASSERT(ASTER_FALSE)
        endif
!
!     ------------------------------------------------------------------
    else if (elrefa.eq.'TR3' .or. elrefa.eq.'TR4' .or. elrefa.eq.'TR6' .or. elrefa.eq.'TR7') then
!
        if (fapg .eq. 'FPG1') then
            xpg(1) = un/3.d0
            ypg(1) = un/3.d0
            hpg(1) = un/deux
        else if (fapg.eq.'FPG3') then
            xpg(1) = un/6.d0
            ypg(1) = un/6.d0
            xpg(2) = 2.d0/3.d0
            ypg(2) = un/6.d0
            xpg(3) = un/6.d0
            ypg(3) = 2.d0/3.d0
            hpg(1) = un/6.d0
            hpg(2) = un/6.d0
            hpg(3) = un/6.d0
        else if (fapg.eq.'FPG4') then
            xpg(1) = 0.2d0
            ypg(1) = 0.2d0
            xpg(2) = 0.6d0
            ypg(2) = 0.2d0
            xpg(3) = 0.2d0
            ypg(3) = 0.6d0
            xpg(4) = un/3.d0
            ypg(4) = un/3.d0
            hpg(1) = 25.d0/96.d0
            hpg(2) = 25.d0/96.d0
            hpg(3) = 25.d0/96.d0
            hpg(4) = -27.d0/96.d0
        else if (fapg.eq.'FPG6') then
            p1 = 0.111690794839005d0
            p2 = 0.054975871827661d0
            xa = 0.445948490915965d0
            xb = 0.091576213509771d0
            xpg(3) = ( t(xb) + un ) / deux
            ypg(3) = ( t(un-deux*xb) + un ) / deux
            xpg(1) = ( t(xb) + un ) / deux
            ypg(1) = ( t(xb) + un ) / deux
            xpg(2) = ( t(un-deux*xb) + un ) / deux
            ypg(2) = ( t(xb) + un ) / deux
            xpg(6) = ( t(un-deux*xa) + un ) / deux
            ypg(6) = ( t(xa) + un ) / deux
            xpg(4) = ( t(xa) + un ) / deux
            ypg(4) = ( t(un-deux*xa) + un ) / deux
            xpg(5) = ( t(xa) + un ) / deux
            ypg(5) = ( t(xa) + un ) / deux
            hpg(1) = p2
            hpg(2) = p2
            hpg(3) = p2
            hpg(4) = p1
            hpg(5) = p1
            hpg(6) = p1
        else if (fapg.eq.'FPG7') then
            p1 = 0.066197076394253d0
            p2 = 0.062969590272413d0
            a2 = 0.470142064105115d0
            b2 = 0.101286507323456d0
            xpg(1) = 0.333333333333333d0
            ypg(1) = 0.333333333333333d0
            xpg(2) = a2
            ypg(2) = a2
            xpg(3) = un - deux*a2
            ypg(3) = a2
            xpg(4) = a2
            ypg(4) = un - deux*a2
            xpg(5) = b2
            ypg(5) = b2
            xpg(6) = un - deux*b2
            ypg(6) = b2
            xpg(7) = b2
            ypg(7) = un - deux*b2
            hpg(1) = 9.d0/80.d0
            hpg(2) = p1
            hpg(3) = p1
            hpg(4) = p1
            hpg(5) = p2
            hpg(6) = p2
            hpg(7) = p2
        else if (fapg.eq.'FPG12') then
            a1=0.063089014491502d0
            b1=0.249286745170910d0
            c1=0.310352451033785d0
            d1=0.053145049844816d0
            xpg(1) = a1
            ypg(1) = a1
            xpg(2) = un - deux*a1
            ypg(2) = a1
            xpg(3) = a1
            ypg(3) = un - deux*a1
            xpg(4) = b1
            ypg(4) = b1
            xpg(5) = un - deux*b1
            ypg(5) = b1
            xpg(6) = b1
            ypg(6) = un - deux*b1
            xpg(7) = c1
            ypg(7) = d1
            xpg(8) = d1
            ypg(8) = c1
            xpg(9) = un - c1 - d1
            ypg(9) = c1
            xpg(10) = un - c1 - d1
            ypg(10) = d1
            xpg(11) = c1
            ypg(11) = un - c1 - d1
            xpg(12) = d1
            ypg(12) = un - c1 - d1
            p1=0.025422453185103d0
            p2=0.058393137863189d0
            p3=0.041425537809187d0
            hpg(1) = p1
            hpg(2) = p1
            hpg(3) = p1
            hpg(4) = p2
            hpg(5) = p2
            hpg(6) = p2
            hpg(7) = p3
            hpg(8) = p3
            hpg(9) = p3
            hpg(10) = p3
            hpg(11) = p3
            hpg(12) = p3
        else if (fapg.eq.'FPG13') then
!
!         FORMULE A 13 POINTS : ORDRE 7  (CF BATHE :
!         FINITE ELEMENT PROCEDURES IN ENGINEERING ANALYSIS, PAGE 280)
!
            xpg(1) = 0.0651301029022d0
            ypg(1) = 0.0651301029022d0
            xpg(2) = 0.8697397941956d0
            ypg(2) = 0.0651301029022d0
            xpg(3) = 0.0651301029022d0
            ypg(3) = 0.8697397941956d0
            xpg(4) = 0.3128654960049d0
            ypg(4) = 0.0486903154253d0
            xpg(5) = 0.6384441885698d0
            ypg(5) = 0.3128654960049d0
            xpg(6) = 0.0486903154253d0
            ypg(6) = 0.6384441885698d0
            xpg(7) = 0.6384441885698d0
            ypg(7) = 0.0486903154253d0
            xpg(8) = 0.3128654960049d0
            ypg(8) = 0.6384441885698d0
            xpg(9) = 0.0486903154253d0
            ypg(9) = 0.3128654960049d0
            xpg(10) = 0.2603459660790d0
            ypg(10) = 0.2603459660790d0
            xpg(11) = 0.4793080678419d0
            ypg(11) = 0.2603459660790d0
            xpg(12) = 0.2603459660790d0
            ypg(12) = 0.4793080678419d0
            xpg(13) = 0.3333333333333d0
            ypg(13) = 0.3333333333333d0
            p1= 0.0533472356088d0/2.d0
            p2= 0.0771137608903d0/2.d0
            p3= 0.1756152574332d0/2.d0
            p4= -0.1495700444677d0/2.d0
            hpg(1) = p1
            hpg(2) = p1
            hpg(3) = p1
            hpg(4) = p2
            hpg(5) = p2
            hpg(6) = p2
            hpg(7) = p2
            hpg(8) = p2
            hpg(9) = p2
            hpg(10) = p3
            hpg(11) = p3
            hpg(12) = p3
            hpg(13) = p4
        else if (fapg.eq.'FPG16') then
            xpg(1) = 0.333333333333333d0
            ypg(1) = 0.333333333333333d0
            xpg(2) = 0.081414823414554d0
            ypg(2) = 0.459292588292723d0
            xpg(3) = 0.459292588292723d0
            ypg(3) = 0.081414823414554d0
            xpg(4) = 0.459292588292723d0
            ypg(4) = 0.459292588292723d0
            xpg(5) = 0.658861384496480d0
            ypg(5) = 0.170569307751760d0
            xpg(6) = 0.170569307751760d0
            ypg(6) = 0.658861384496480d0
            xpg(7) = 0.170569307751760d0
            ypg(7) = 0.170569307751760d0
            xpg(8) = 0.898905543365938d0
            ypg(8) = 0.050547228317031d0
            xpg(9) = 0.050547228317031d0
            ypg(9) = 0.898905543365938d0
            xpg(10) = 0.050547228317031d0
            ypg(10) = 0.050547228317031d0
            xpg(11) = 0.008394777409958d0
            ypg(11) = 0.728492392955404d0
            xpg(12) = 0.728492392955404d0
            ypg(12) = 0.008394777409958d0
            xpg(13) = 0.263112829634638d0
            ypg(13) = 0.008394777409958d0
            xpg(14) = 0.008394777409958d0
            ypg(14) = 0.263112829634638d0
            xpg(15) = 0.263112829634638d0
            ypg(15) = 0.728492392955404d0
            xpg(16) = 0.728492392955404d0
            ypg(16) = 0.263112829634638d0
            p1= 0.144315607677787d0/2.d0
            p2= 0.095091634267285d0/2.d0
            p3= 0.103217370534718d0/2.d0
            p4= 0.032458497623198d0/2.d0
            p5= 0.027230314174435d0/2.d0
            hpg(1) = p1
            hpg(2) = p2
            hpg(3) = p2
            hpg(4) = p2
            hpg(5) = p3
            hpg(6) = p3
            hpg(7) = p3
            hpg(8) = p4
            hpg(9) = p4
            hpg(10) = p4
            hpg(11) = p5
            hpg(12) = p5
            hpg(13) = p5
            hpg(14) = p5
            hpg(15) = p5
            hpg(16) = p5
!
        else if (fapg.eq.'COT3') then
            xpg(1) = undemi
            ypg(1) = undemi
            xpg(2) = zero
            ypg(2) = undemi
            xpg(3) = undemi
            ypg(3) = zero
            hpg(1) = un/6.d0
            hpg(2) = un/6.d0
            hpg(3) = un/6.d0
!
        else if (fapg.eq.'SIMP') then
            xpg(1) = 0.d0
            ypg(1) = 0.d0
            xpg(2) = 1.d0
            ypg(2) = 0.d0
            xpg(3) = 0.d0
            ypg(3) = 1.d0
            xpg(4) = 0.5d0
            ypg(4) = 0.d0
            xpg(5) = 0.5d0
            ypg(5) = 0.5d0
            xpg(6) = 0.d0
            ypg(6) = 0.5d0
            hpg(1) = 1.d0 / 30.d0
            hpg(2) = 1.d0 / 30.d0
            hpg(3) = 1.d0 / 30.d0
            hpg(4) = 4.d0 / 30.d0
            hpg(5) = 4.d0 / 30.d0
            hpg(6) = 4.d0 / 30.d0
!
        else if (fapg.eq.'FPG3NOS') then
! ------- POUR LES POINTS DE GAUSS -------------------------------------
            xpg(1) = un/6.d0
            ypg(1) = un/6.d0
            xpg(2) = 2.d0/3.d0
            ypg(2) = un/6.d0
            xpg(3) = un/6.d0
            ypg(3) = 2.d0/3.d0
            hpg(1) = un/6.d0
            hpg(2) = un/6.d0
            hpg(3) = un/6.d0
! ------- POUR LES SOMMETS ---------------------------------------------
            do ino = 1,nnos
                hpg(ino+3) = vol/nnos
                xpg(ino+3) = xno(ndim* (ino-1)+1)
                if (ndim .ge. 2) ypg(ino+3) = xno(ndim* (ino-1)+2)
                if (ndim .eq. 3) zpg(ino+3) = xno(ndim* (ino-1)+3)
            end do
        else
            ASSERT(ASTER_FALSE)
        endif
!
!     ------------------------------------------------------------------
    else if ( elrefa.eq.'QU4' .or. elrefa.eq.'QU8' .or. elrefa.eq.'QU9') then
!
        if (fapg .eq. 'FPG1') then
            xpg(1) = zero
            ypg(1) = zero
            hpg(1) = 4.d0
        else if (fapg.eq.'FIS2') then
! ------- ELEMENT PARTICULIER DE FISSURE, S'APPUIE SUR UN SEG2
            xpg(1) = -0.577350269189626d0
            ypg(1) = zero
            xpg(2) = 0.577350269189626d0
            ypg(2) = zero
            hpg(1) = deux
            hpg(2) = deux
        else if (fapg.eq.'FPG4') then
            xpg(1) = -0.577350269189626d0
            ypg(1) = -0.577350269189626d0
            xpg(2) = 0.577350269189626d0
            ypg(2) = -0.577350269189626d0
            xpg(3) = 0.577350269189626d0
            ypg(3) = 0.577350269189626d0
            xpg(4) = -0.577350269189626d0
            ypg(4) = 0.577350269189626d0
            hpg(1) = un
            hpg(2) = un
            hpg(3) = un
            hpg(4) = un
        else if (fapg.eq.'FPG9') then
            hpg(1) = 25.d0/81.0d0
            hpg(2) = 25.d0/81.0d0
            hpg(3) = 25.d0/81.0d0
            hpg(4) = 25.d0/81.0d0
            hpg(5) = 40.d0/81.0d0
            hpg(6) = 40.d0/81.0d0
            hpg(7) = 40.d0/81.0d0
            hpg(8) = 40.d0/81.0d0
            hpg(9) = 64.d0/81.0d0
            xpg(1) = -0.774596669241483d0
            ypg(1) = -0.774596669241483d0
            xpg(2) = 0.774596669241483d0
            ypg(2) = -0.774596669241483d0
            xpg(3) = 0.774596669241483d0
            ypg(3) = 0.774596669241483d0
            xpg(4) = -0.774596669241483d0
            ypg(4) = 0.774596669241483d0
            xpg(5) = zero
            ypg(5) = -0.774596669241483d0
            xpg(6) = 0.774596669241483d0
            ypg(6) = zero
            xpg(7) = zero
            ypg(7) = 0.774596669241483d0
            xpg(8) = -0.774596669241483d0
            ypg(8) = zero
            xpg(9) = zero
            ypg(9) = zero
        else if (fapg.eq.'FPG9COQ') then
            hpg(7) = 25.d0/81.0d0
            hpg(1) = 25.d0/81.0d0
            hpg(3) = 25.d0/81.0d0
            hpg(5) = 25.d0/81.0d0
            hpg(8) = 40.d0/81.0d0
            hpg(2) = 40.d0/81.0d0
            hpg(4) = 40.d0/81.0d0
            hpg(6) = 40.d0/81.0d0
            hpg(9) = 64.d0/81.0d0
            xpg(1) = -0.774596669241483d0
            ypg(1) = -0.774596669241483d0
            xpg(3) = 0.774596669241483d0
            ypg(3) = -0.774596669241483d0
            xpg(5) = 0.774596669241483d0
            ypg(5) = 0.774596669241483d0
            xpg(7) = -0.774596669241483d0
            ypg(7) = 0.774596669241483d0
            xpg(2) = zero
            ypg(2) = -0.774596669241483d0
            xpg(4) = 0.774596669241483d0
            ypg(4) = zero
            xpg(6) = zero
            ypg(6) = 0.774596669241483d0
            xpg(8) = -0.774596669241483d0
            ypg(8) = zero
            xpg(9) = zero
            ypg(9) = zero
        else if (fapg.eq.'FPG16') then
            h(1) = 0.652145154862546d0
            h(2) = h(1)
            h(3) = 0.347854845137454d0
            h(4) = h(3)
            a(1) = -0.339981043584856d0
            a(2) = -a(1)
            a(3) = -0.861136311594053d0
            a(4) = -a(3)
            npar = 4
            npi = 0
            do ix = 1, npar
                do iy = 1, npar
                    npi = npi + 1
                    xpg(npi) = a(ix)
                    ypg(npi) = a(iy)
                    hpg(npi) = h(ix)*h(iy)
                end do
            end do
        else if (fapg.eq.'FPG4NOS') then
! ------- POUR LES POINTS DE GAUSS -------------------------------------
            xpg(1) = -0.577350269189626d0
            ypg(1) = -0.577350269189626d0
            xpg(2) = 0.577350269189626d0
            ypg(2) = -0.577350269189626d0
            xpg(3) = 0.577350269189626d0
            ypg(3) = 0.577350269189626d0
            xpg(4) = -0.577350269189626d0
            ypg(4) = 0.577350269189626d0
            hpg(1) = un
            hpg(2) = un
            hpg(3) = un
            hpg(4) = un
! ------- POUR LES SOMMETS ---------------------------------------------
            do ino = 1,nnos
                hpg(ino+4) = vol/nnos
                xpg(ino+4) = xno(ndim* (ino-1)+1)
                if (ndim .ge. 2) ypg(ino+4) = xno(ndim* (ino-1)+2)
                if (ndim .eq. 3) zpg(ino+4) = xno(ndim* (ino-1)+3)
            end do
!
        else
            ASSERT(ASTER_FALSE)
        endif
!
!     ------------------------------------------------------------------
    else if (elrefa.eq.'SE2' .or. elrefa.eq.'SE3' .or. elrefa.eq.'SE4') then
!
        if (fapg .eq. 'FPG1') then
            xpg(1) = zero
            hpg(1) = deux
        else if (fapg .eq. 'FPG2') then
            xpg(1) = 0.577350269189626d0
            xpg(2) = -xpg(1)
            hpg(1) = un
            hpg(2) = hpg(1)
!
        else if (fapg.eq.'FPG3') then
            xpg(1) = -0.774596669241483d0
            xpg(2) = 0.d0
            xpg(3) = 0.774596669241483d0
            hpg(1) = 0.555555555555556d0
            hpg(2) = 0.888888888888889d0
            hpg(3) = 0.555555555555556d0
!
        else if (fapg.eq.'FPG4') then
            xpg(1) = 0.339981043584856d0
            xpg(2) = -xpg(1)
            xpg(3) = 0.861136311594053d0
            xpg(4) = -xpg(3)
            hpg(1) = 0.652145154862546d0
            hpg(2) = hpg(1)
            hpg(3) = 0.347854845137454d0
            hpg(4) = hpg(3)
!
        else if (fapg.eq.'FPG2NOS') then
            xpg(1) = 0.577350269189626d0
            xpg(2) = -xpg(1)
            xpg(3) = xno(1)
            xpg(4) = xno(2)
!
            hpg(1) = un
            hpg(2) = hpg(1)
            hpg(3) = vol/nnos
            hpg(4) = hpg(3)
!
        else if (fapg.eq.'FPG3NOS') then
            xpg(1) = -0.774596669241483d0
            xpg(2) = 0.d0
            xpg(3) = 0.774596669241483d0
            xpg(4) = xno(1)
            xpg(5) = xno(nnos)
            hpg(1) = 0.555555555555556d0
            hpg(2) = 0.888888888888889d0
            hpg(3) = 0.555555555555556d0
            hpg(4) = vol/nnos
            hpg(5) = hpg(4)
!
        else if (fapg.eq.'SIMP') then
            xpg(1) = -1.d0
            xpg(2) = 0.d0
            xpg(3) = 1.d0
            hpg(1) = 1.d0 / 3.d0
            hpg(2) = 4.d0 / 3.d0
            hpg(3) = 1.d0 / 3.d0
!
        else if (fapg.eq.'SIMP1') then
            xpg(1) = -1.d0
            xpg(2) = -0.5d0
            xpg(3) = 0.d0
            xpg(4) = 0.5d0
            xpg(5) = 1.d0
            hpg(1) = 1.d0 / 6.d0
            hpg(2) = 2.d0 / 3.d0
            hpg(3) = 1.d0 / 3.d0
            hpg(4) = 2.d0 / 3.d0
            hpg(5) = 1.d0 / 6.d0
!
!
        else if (fapg.eq.'COTES') then
            xpg(1) = -1.d0
            xpg(2) = -1.d0/3.d0
            xpg(3) = 1.d0/3.d0
            xpg(4) = 1.d0
            hpg(1) = 1.d0/4.d0
            hpg(2) = 3.d0/4.d0
            hpg(3) = 3.d0/4.d0
            hpg(4) = 1.d0/4.d0
!
        else if (fapg.eq.'COTES1') then
            xpg(1) = -1.d0
            xpg(2) = -1.d0/2.d0
            xpg(3) = 0.d0
            xpg(4) = 1.d0/2.d0
            xpg(5) = 1.d0
            hpg(1) = 7.d0/45.d0
            hpg(2) = 32.d0/45.d0
            hpg(3) = 12.d0/45.d0
            hpg(4) = 32.d0/45.d0
            hpg(5) = 7.d0/45.d0
!
        else if (fapg.eq.'COTES2') then
            xpg(1) = -1.d0
            xpg(2) = -7.d0/9.d0
            xpg(3) = -5.d0/9.d0
            xpg(4) = -1.d0/3.d0
            xpg(5) = -1.d0/9.d0
            xpg(6) = 1.d0/9.d0
            xpg(7) = 1.d0/3.d0
            xpg(8) = 5.d0/9.d0
            xpg(9) = 7.d0/9.d0
            xpg(10) = 1.d0
            hpg(1) = 1.d0/12.d0
            hpg(2) = 1.d0/4.d0
            hpg(3) = 1.d0/4.d0
            hpg(4) = 1.d0/6.d0
            hpg(5) = 1.d0/4.d0
            hpg(6) = 1.d0/4.d0
            hpg(7) = 1.d0/6.d0
            hpg(8) = 1.d0/4.d0
            hpg(9) = 1.d0/4.d0
            hpg(10) = 1.d0/12.d0
!
        else
            ASSERT(ASTER_FALSE)
        endif
!
!     ------------------------------------------------------------------
    else if (elrefa.eq.'PO1') then
        hpg(1) = 1.d0
!
!
!     ------------------------------------------------------------------
    else
        ASSERT(ASTER_FALSE)
    endif
!
170  continue
!     ------------------------------------------------------------------
    do i = 1, nbpg
        poipg(i) = hpg(i)
        if (ndim .ge. 1) coopg(ndim* (i-1)+1) = xpg(i)
        if (ndim .ge. 2) coopg(ndim* (i-1)+2) = ypg(i)
        if (ndim .eq. 3) coopg(ndim* (i-1)+3) = zpg(i)
    end do
end subroutine
