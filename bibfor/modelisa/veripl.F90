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

subroutine veripl(ma, nbma, linuma, ang, typerr)
    implicit none
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
    character(len=*) :: ma
    integer :: nbma,  jconx, ima, k, iprem, numai1, numail, linuma(nbma)
    real(kind=8) :: n1(3), n(3), ab(3), ac(3), nn, n1n, n1n1
    real(kind=8) :: cos2b, cos2a, a(3), b(3), c(3), ang
    character(len=1) :: typerr
    character(len=8) :: ma2, nomail, nomai1
! -------------------------------------------------------
! BUT : VERIFIER LA PLANEITE D'UNE LISTE DE MAILLES
! -------------------------------------------------------
!  MA    IN   K8 : NOM DU MAILLAGE
!  NBMA  IN   I  : NOMBRE DE MAILLES DANS LINUMA
!  LINUMA IN  V(I): LISTE DES NUMEROS DES MAILLES DONT ON VEUT
!                    VERIFIER LA PLANEITE.
!  ANG   IN   R  : ANGLE (EN DEGRE) QUE NE DOIT PAS DEPASSER
!                  LA NORMALE DES FACETTES 2,3,... AVEC LA FACETTE 1
!  TYPERR IN  K1 : /'A' -> <A>LARME SI NECESSAIRE
!                  /'F' -> ERREUR <F>ATALE SI NECESSAIRE
!
! REMARQUES :
!   ON CALCULE TOUS LES ANGLES QUE FONT LES MAILLES 2,3,...,N
!   AVEC LA 1ERE. L'ANGLE MAX ENTRE 2 MAILLES QUELCONQUES
!   EST DONC INFERIEUR A 2*ANG
!
!   LA NORMALE A UNE FACETTE EST CALCULEE AVEC SES 3 1ER SOMMETS
!
!   LES MAILLES DE LINUMA DOIVENT ETRE "SURFACIQUES" 3D
!   (LE PROGRAMME NE VERIFIE PAS CETTE CONDITION)
! -------------------------------------------------------
    character(len=24) :: valk(2)
    real(kind=8), pointer :: vale(:) => null()
!
!
    call jemarq()
    ma2 = ma
!
    call jeveuo(ma2//'.COORDO    .VALE', 'L', vr=vale)
!
    cos2b = cos(ang*r8dgrd())**2
!
    iprem = 0
    do 20,ima = 1,nbma
    numail = linuma(ima)
    call jeveuo(jexnum(ma2//'.CONNEX', numail), 'L', jconx)
!
!       -- VERIFIER NOMAIL : TRIA OU QUAD ???
!
!       CALCUL DE LA NORMALE (N) A LA FACETTE IMA :
    do 10,k = 1,3
    a(k) = vale(3* (zi(jconx-1+1)-1)+k)
    b(k) = vale(3* (zi(jconx-1+2)-1)+k)
    c(k) = vale(3* (zi(jconx-1+3)-1)+k)
    ab(k) = b(k) - a(k)
    ac(k) = c(k) - a(k)
10  continue
    n(1) = ab(2)*ac(3) - ab(3)*ac(2)
    n(2) = ab(3)*ac(1) - ab(1)*ac(3)
    n(3) = ab(1)*ac(2) - ab(2)*ac(1)
!
!
    iprem = iprem + 1
    if (iprem .eq. 1) then
        n1(1) = n(1)
        n1(2) = n(2)
        n1(3) = n(3)
        numai1 = numail
        goto 20
    endif
!
    nn = n(1)*n(1) + n(2)*n(2) + n(3)*n(3)
    n1n = n1(1)*n(1) + n1(2)*n(2) + n1(3)*n(3)
    n1n1 = n1(1)*n1(1) + n1(2)*n1(2) + n1(3)*n1(3)
!
    cos2a = (n1n*n1n)/ (nn*n1n1)
!
    if (cos2a .lt. cos2b) then
        call jenuno(jexnum(ma2//'.NOMMAI', numail), nomail)
        call jenuno(jexnum(ma2//'.NOMMAI', numai1), nomai1)
        valk(1) = nomai1
        valk(2) = nomail
        call utmess(typerr, 'MODELISA7_80', nk=2, valk=valk)
    endif
!
    20 end do
!
    call jedema()
!
end subroutine
