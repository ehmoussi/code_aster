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

subroutine cuaca2(deficu, resocu, nbliac, spliai, indfac,&
                  lmat, xjvmax)
!
!
    implicit      none
#include "jeveux.h"
!
#include "asterfort/caladu.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelibe.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
    character(len=24) :: deficu, resocu
    integer :: nbliac
    integer :: spliai
    integer :: indfac
    integer :: lmat
    real(kind=8) :: xjvmax
!
! ----------------------------------------------------------------------
!
! ROUTINE LIAISON_UNILATER (RESOLUTION - A.C-1.AT)
!
! CALCUL DE -A.C-1.AT (REDUITE AUX LIAISONS ACTIVES)
! STOCKAGE DE LA MOITIE UNIQUEMENT (PROBLEME SYMETRIQUE)
!
! ----------------------------------------------------------------------
!
!
! IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
! I/O SPLIAI : INDICE DANS LA LISTE DES LIAISONS ACTIVES DE LA DERNIERE
!              LIAISON AYANT ETE CALCULEE POUR LE VECTEUR CM1A
! I/O INDFAC : INDICE DE DEBUT DE LA FACTORISATION
! IN  LMAT   : DESCRIPTEUR DE LA MATR_ASSE DU SYSTEME MECANIQUE
! I/O XJVMAX : VALEUR DU PIVOT MAX
! IN  DEFICU : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
! IN  RESOCU : SD DE TRAITEMENT NUMERIQUE
!
!
!
!
    integer :: jdecal
    integer :: nbddl, jva, jvale, jpoi, neq
    integer :: iliac, jj, lliac, lljac,  ii, dercol, bloc
    integer ::  jouv,  nbbloc
    real(kind=8) :: val
    character(len=19) :: liac, cm1a, matr, stoc, ouvert
    integer :: jliac, jcm1a
    character(len=24) :: apddl, apcoef, poinoe
    integer :: japddl, japcoe
    integer, pointer :: scbl(:) => null()
    integer, pointer :: scde(:) => null()
    integer, pointer :: scib(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
! ======================================================================
    poinoe = deficu(1:16)//'.POINOE'
    cm1a = resocu(1:14)//'.CM1A'
    apddl = resocu(1:14)//'.APDDL'
    liac = resocu(1:14)//'.LIAC'
    apcoef = resocu(1:14)//'.APCOEF'
    matr = resocu(1:14)//'.MATC'
    stoc = resocu(1:14)//'.SLCS'
    call jeveuo(apddl, 'L', japddl)
    call jeveuo(liac, 'L', jliac)
    call jeveuo(apcoef, 'L', japcoe)
    call jeveuo(poinoe, 'L', jpoi)
    call jeveuo(stoc//'.SCIB', 'L', vi=scib)
    call jeveuo(stoc//'.SCBL', 'L', vi=scbl)
    call jeveuo(stoc//'.SCDE', 'L', vi=scde)
!
! --- INITIALISATIONS
!
    neq = zi(lmat+2)
    nbbloc = scde(3)
    ouvert = '&CFACA2.TRAV'
    call wkvect(ouvert, 'V V L', nbbloc, jouv)
!
! --- CALCUL DE -A.C-1.AT (REDUITE AUX LIAISONS ACTIVES)
! --- (STOCKAGE DE LA MOITIE PAR SYMETRIE)
!
    indfac = min(indfac, spliai+1)
!
    do 210 iliac = spliai+1, nbliac
        lliac = zi(jliac-1+iliac)
!
        call jeveuo(jexnum(cm1a, lliac), 'L', jcm1a)
        ii = scib(iliac)
        dercol = scbl(ii)
        bloc = dercol*(dercol+1)/2
        if (.not.zl(jouv-1+ii)) then
            if (ii .gt. 1) then
                call jelibe(jexnum(matr//'.UALF', (ii-1)))
                zl(jouv-2+ii)=.false.
            endif
            call jeveuo(jexnum(matr//'.UALF', ii), 'E', jvale)
            zl(jouv-1+ii)=.true.
        endif
        jva = jvale-1 + (iliac-1)*(iliac)/2-bloc
        do 10 jj = 1, iliac
            lljac = zi(jliac-1+jj)
            jdecal = zi(jpoi+lljac-1)
            nbddl = zi(jpoi+lljac) - zi(jpoi+lljac-1)
            jva = jva + 1
            zr(jva) = 0.0d0
            call caladu(neq, nbddl, zr(japcoe+jdecal), zi(japddl+jdecal), zr(jcm1a),&
                        val)
            zr(jva) = zr(jva) - val
            if (abs(zr(jva)) .gt. xjvmax) xjvmax = abs(zr(jva))
10      continue
        call jelibe(jexnum(cm1a, lliac))
210  end do
! ======================================================================
    spliai = nbliac
    call jedetr(ouvert)
    call jedema()
! ======================================================================
!
end subroutine
