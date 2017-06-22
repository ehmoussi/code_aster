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

subroutine mtmchc(matas, action)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/asmchc.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
    character(len=*) :: matas, action
! OBJET :
!        TRAITEMENT DES CHARGES CINEMATIQUES DANS UNE MATRICE ASSEMBLEE
!        SI ACTION='ELIMF' :
!            - ON UTILISE .CCID POUR :
!                CALCULER .CCVA, .CCLL, .CCII
!                MODIFIER .VALM
!        SI ACTION='ELIML' :
!            - ON UTILISE .CCVA POUR :
!                RETABLIR (EN PARTIE SEULEMENT) .VALM
!                DETRUIRE .CCVA, .CCLL, .CCII
!-----------------------------------------------------------------------
! VAR  MATAS   K*19    : NOM DE LA MATR_ASSE
! IN   ACTION  K*5     : /'ELIMF' /'ELIML'
!-----------------------------------------------------------------------
!----------------------------------------------------------------------
!     VARIABLES LOCALES
!----------------------------------------------------------------------
    character(len=8) :: kbid
    character(len=14) :: nu
    character(len=19) :: mat, nomsto
    integer :: typmat, ielim, jelim, kdeb, kfin, ilig, jcol
    integer :: jsmhc, jvalm, jvalm2, jccva, nelim
    integer :: jnequ, ieq, k, deciel, neq, ier
    integer :: nblocm, decjel, iremp, jccid, keta, imatd
    aster_logical :: nonsym
    integer, pointer :: elim(:) => null()
    integer, pointer :: remplis(:) => null()
    integer, pointer :: ccll(:) => null()
    integer, pointer :: smdi(:) => null()
    integer, pointer :: nulg(:) => null()
    character(len=24), pointer :: refa(:) => null()
!----------------------------------------------------------------------
    call jemarq()
    mat = matas
!     CALL CHEKSD('sd_matr_asse',MAT,IRET)
    call jeveuo(mat//'.REFA', 'E', vk24=refa)
    call jeexin(mat//'.CCID', ier)
    if (refa(3) .eq. ' ') then
        ASSERT(ier.eq.0)
        goto 9999
    else
        ASSERT(ier.gt.0)
    endif
!
    if (action .eq. 'ELIMF') then
        ASSERT(refa(3).eq.'ELIML')
        call asmchc(mat)
        goto 9999
    else if (action.eq.'ELIML') then
        ASSERT(refa(3).eq.'ELIMF')
!        TRAITEMENT CI-DESSOUS
    else
        ASSERT(.false.)
    endif
!
!
    call jeveuo(mat//'.CCVA', 'L', jccva)
    call jeveuo(mat//'.CCLL', 'L', vi=ccll)
    call jeveuo(mat//'.CCID', 'L', jccid)
!
!
!
    nu = refa(2)(1:14)
    call jeexin(nu//'.NUML.DELG', imatd)
    if (imatd .ne. 0) then
        call jeveuo(nu//'.NUML.NEQU', 'L', jnequ)
        call jeveuo(nu//'.NUML.NULG', 'L', vi=nulg)
    else
        call jeveuo(nu//'.NUME.NEQU', 'L', jnequ)
    endif
    neq = zi(jnequ)
!
!
    nomsto = nu//'.SMOS'
    call jeveuo(nomsto//'.SMHC', 'L', jsmhc)
    call jeveuo(nomsto//'.SMDI', 'L', vi=smdi)
!
!
!     -- RECUPERATION DE .VALM
!        CALCUL DE TYPMAT ET NONSYM :
!     ------------------------------------
    call jelira(jexnum(mat//'.VALM', 1), 'TYPE', cval=kbid)
    typmat = 1
    if (kbid(1:1) .eq. 'C') typmat = 2
    nonsym=.false.
    call jelira(mat//'.VALM', 'NMAXOC', nblocm)
    ASSERT(nblocm.eq.1 .or. nblocm.eq.2)
    if (nblocm .eq. 2) nonsym=.true.
    call jeveuo(jexnum(mat//'.VALM', 1), 'E', jvalm)
    if (nonsym) call jeveuo(jexnum(mat//'.VALM', 2), 'E', jvalm2)
!
!
!     -- CALCUL DE ELIM(*) ET NELIM :
!     -----------------------------------
!     ELIM    I(*)    : TABLEAU ENTIER DE DIM = NEQ DONNANT LES
!                       LES NUMEROS DES EQUATIONS A ELIMINER ET LEUR
!                       NUMERO D'ELIMINATION
!                       ZI(KKELI-1+IEQ) = / 0      -> PAS ELIMINE
!                                         / IELIM  -> ELIMINE
!     NELIM   I       : NOMBRE D'EQUATIONS DE LA MATRICE A ELIMINER
    AS_ALLOCATE(vi=elim, size=neq)
    call jeveuo(mat//'.CCID', 'L', jccid)
    nelim=0
    do 1 ieq = 1, neq
        if (imatd .ne. 0) then
            keta=zi(jccid-1+nulg(ieq))
        else
            keta=zi(jccid-1+ieq)
        endif
        ASSERT(keta.eq.1 .or. keta.eq.0)
        if (keta .eq. 1) then
            nelim=nelim+1
            elim(ieq)=nelim
        else
            elim(ieq)=0
        endif
  1 end do
!
!
!     -- RECOPIE DE .CCVA DANS .VALM :
!     -----------------------------------------
    AS_ALLOCATE(vi=remplis, size=nelim)
    kfin=0
    do 121 jcol = 1, neq
        kdeb = kfin + 1
        kfin = smdi(jcol)
        jelim = elim(jcol)
!
        if (jelim .ne. 0) then
            deciel=ccll(3*(jelim-1)+3)
            do 111 k = kdeb, kfin - 1
                ilig = zi4(jsmhc-1+k)
                ielim = elim(ilig)
                if (ielim .eq. 0) then
                    remplis(jelim)=remplis(jelim)+1
                    iremp=remplis(jelim)
                    if (typmat .eq. 1) then
                        zr(jvalm-1+k)=zr(jccva-1+deciel+iremp)
                    else
                        zc(jvalm-1+k)=zc(jccva-1+deciel+iremp)
                    endif
                endif
111         continue
!
        else
            do 112 k = kdeb, kfin - 1
                ilig = zi4(jsmhc-1+k)
                ielim = elim(ilig)
                decjel=ccll(3*(ielim-1)+3)
                if (ielim .ne. 0) then
                    remplis(ielim)=remplis(ielim)+1
                    iremp=remplis(ielim)
                    if (typmat .eq. 1) then
                        if (nonsym) then
                            zr(jvalm2-1+k)=zr(jccva-1+decjel+iremp)
                        else
                            zr(jvalm-1+k)=zr(jccva-1+decjel+iremp)
                        endif
                    else
                        if (nonsym) then
                            zc(jvalm2-1+k)=zc(jccva-1+decjel+iremp)
                        else
                            zc(jvalm-1+k)=zc(jccva-1+decjel+iremp)
                        endif
                    endif
                endif
112         continue
        endif
!
121 end do
!
!
    refa(3)='ELIML'
    call jedetr(mat//'.CCVA')
    call jedetr(mat//'.CCLL')
    call jedetr(mat//'.CCII')
    AS_DEALLOCATE(vi=remplis)
    AS_DEALLOCATE(vi=elim)
!
!
9999 continue
!     CALL CHEKSD('sd_matr_asse',MAT,IRET)
    call jedema()
end subroutine
