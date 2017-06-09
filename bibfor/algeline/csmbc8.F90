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

subroutine csmbc8(nommat, ccll, ccii, neq, vcine,&
                  vsmb)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelibe.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    character(len=*) :: nommat
    complex(kind=8) :: vsmb(*), vcine(*)
    integer :: ccll(*), ccii(*), neq
! BUT : CALCUL DE LA CONTRIBUTION AU SECOND MEMBRE DES DDLS IMPOSES
!       LORSQU'ILS SONT TRAITEES PAR ELIMINATION (CAS COMPLEXE)
! C.F. EXPLICATIONS DANS LA ROUTINE CSMBGG
!-----------------------------------------------------------------------
! IN  NOMMAT K19 : NOM DE LA MATR_ASSE
! IN  CCLL   I(*): TABLEAU .CCLL DE LA MATRICE
! IN  CCII   I(*): TABLEAU .CCII DE LA MATRICE
! IN  NEQ    I   : NOMBRE D'EQUATIONS
! VAR VSMB   R(*): VECTEUR SECOND MEMBRE
! IN  VCINE  R(*): VECTEUR DE CHARGEMENT CINEMATIQUE ( LE U0 DE U = U0
!                 SUR G AVEC VCINE = 0 EN DEHORS DE G )
!-----------------------------------------------------------------------
!     FONCTIONS JEVEUX
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!     VARIABLES LOCALES
!-----------------------------------------------------------------------
    integer ::   nelim, ielim, ieq, j,   ieqg
    integer :: deciel, kterm, nterm, imatd
    complex(kind=8) :: coef
    character(len=14) :: nu
    character(len=19) :: mat
    character(len=24), pointer :: refa(:) => null()
    integer, pointer :: nulg(:) => null()
    complex(kind=8), pointer :: ccva(:) => null()
    integer, pointer :: ccid(:) => null()
    integer, pointer :: nugl(:) => null()
!-----------------------------------------------------------------------
!     DEBUT
    call jemarq()
!-----------------------------------------------------------------------
    mat = nommat
!
    call jeveuo(mat//'.CCVA', 'L', vc=ccva)
    call jelira(mat//'.CCLL', 'LONMAX', nelim)
    nelim=nelim/3
!
    call jeveuo(mat//'.REFA', 'L', vk24=refa)
    if (refa(11) .eq. 'MATR_DISTR') then
        imatd = 1
        nu = refa(2)(1:14)
        call jeveuo(nu//'.NUML.NULG', 'L', vi=nulg)
        call jeveuo(nu//'.NUML.NUGL', 'L', vi=nugl)
    else
        imatd = 0
    endif
!
    do 20 ielim = 1, nelim
        ieq = ccll(3*(ielim-1)+1)
        nterm = ccll(3*(ielim-1)+2)
        deciel = ccll(3*(ielim-1)+3)
!
        if (imatd .eq. 0) then
            ieqg = ieq
        else
            ieqg = nulg(ieq)
        endif
        coef = vcine(ieqg)
!
        if (coef .ne. 0.d0) then
            do 10 kterm = 1, nterm
                if (imatd .eq. 0) then
                    j=ccii(deciel+kterm)
                else
                    j=nulg(ccii(deciel+kterm) )
                endif
                vsmb(j) = vsmb(j) - coef*ccva(deciel+kterm)
10          continue
        endif
!
20  end do
    call jelibe(mat//'.CCVA')
!
    if (imatd .ne. 0) then
        do 40 ieq = 1, neq
            if (nugl(ieq) .eq. 0) vcine(ieq) = 0.d0
40      continue
    endif
!
!
    call jeveuo(mat//'.CCID', 'L', vi=ccid)
    do 30 ieq = 1, neq
        if (ccid(ieq) .eq. 1) then
            vsmb(ieq) = vcine(ieq)
        else
            if (vcine(ieq) .ne. dcmplx(0.d0,0.d0)) then
                call utmess('F', 'ALGELINE_32')
            endif
        endif
!
30  end do
!
    call jedema()
end subroutine
