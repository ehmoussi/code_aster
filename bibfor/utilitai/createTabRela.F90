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

subroutine createTabRela(lisrez, load, motfac_liai)
    implicit none
! person_in_charge: mickael.abbas at edf.fr
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ltcrsd.h"
#include "asterfort/ltnotb.h"
#include "asterfort/tbajli.h"
#include "asterfort/tbajpa.h"
#include "asterfort/tbcrsd.h"
!
    character(len=*), intent(in) :: lisrez
    character(len=8), intent(in) :: load
    character(len=16), intent(in) :: motfac_liai
!
! -------------------------------------------------------
!  creation d'une table à partir d'une liste de relation
!  la table créée est utilisée par CALC_EUROPLEXUS
! -------------------------------------------------------
!     si la sd_liste_rela n'existe pas, on ne fait rien.
! -------------------------------------------------------
    character(len=19) :: lisrel, table
    character(len=4) :: typval, typcoe
    integer :: iexi, nbpar, ino, nbrela
    integer :: ipntrl, nbterm, idecal, jrlcof, idnoeu, iddl, jrlbe
    integer :: jrlpo, jrlco, jrldd, jrlno, ibid, irela
    real(kind=8) :: beta, coef, rbid
    complex(kind=8) :: cbid
    character(len=8) :: nompar(4), noeud, comp
    character(len=2) :: typpar(4)
    integer, pointer :: rlnr(:) => null()
    character(len=8), pointer :: rltc(:) => null()
    integer, pointer :: rlnt(:) => null()
    integer, pointer :: rlsu(:) => null()
    character(len=8), pointer :: rltv(:) => null()
!    data          nompar /'NB_TERME','SM      ','NOEUD   ','COMP    ','COEF    '/
!    data          typpar /'I ','R ','K8','K8','R '/
    data          nompar /'NB_TERME','NOEUD   ','COMP    ','COEF    '/
    data          typpar /'I ','K8','K8','R '/
! -------------------------------------------------------

    call jemarq()
!   
    rbid = 0.0
    ibid = 0
    cbid = CMPLX(0.0,0.0)
    lisrel=lisrez
    call jeexin(lisrel//'.RLCO', iexi)
    if (iexi .eq. 0) goto 999
    
!   creation de la sd l_table et de la table
    call jeexin(load//'           .LTNT', iexi)
    if (iexi .eq. 0) call ltcrsd(load, 'G')
    table = ' '
    call ltnotb(load, motfac_liai, table)
    call jeexin(table//'.TBBA', iexi)
    if (iexi .eq. 0) then 
        call tbcrsd(table, 'G')
    else
        ASSERT(.false.)
    endif
    
!   types de valeurs
    call jeveuo(lisrel//'.RLTC', 'L', vk8=rltc)
    typcoe=rltc(1)(1:4)
    call jeveuo(lisrel//'.RLTV', 'L', vk8=rltv)
    typval=rltv(1)(1:4)
    ASSERT(typcoe.eq.'REEL')
    ASSERT(typval.eq.'REEL')
!
    call jeveuo(lisrel//'.RLNR', 'L', vi=rlnr)
    nbrela=rlnr(1)
    call jeveuo(lisrel//'.RLPO', 'L', jrlpo) ! adresse
    call jeveuo(lisrel//'.RLCO', 'L', jrlco) ! coef
    call jeveuo(lisrel//'.RLDD', 'L', jrldd) ! ddls
    call jeveuo(lisrel//'.RLNO', 'L', jrlno) ! noeud
    call jeveuo(lisrel//'.RLNT', 'L', vi=rlnt) ! nb termes
    call jeveuo(lisrel//'.RLSU', 'L', vi=rlsu) ! relation a prendre en compte ou non
    call jeveuo(lisrel//'.RLBE', 'L', jrlbe) ! second membre

!   parametres de la table
    nbpar = 4
    call tbajpa(table, nbpar, nompar, typpar)
    
    do irela = 1, nbrela
        if (rlsu(irela) .ne. 0) cycle

        nbterm=rlnt(irela)
        beta=zr(jrlbe+irela-1)
!       on accepte uniquement les relations a second membre nul
!       car EPX ne permet pas des relations avec second membre
        ASSERT(beta.eq.0.d0)
        nbpar = 1
        call tbajli(table, nbpar, nompar(1), [nbterm], [rbid],&
                    [cbid], [' '], 0)
        
        ipntrl=zi(jrlpo+irela-1)
        idecal=ipntrl-nbterm
        jrlcof=jrlco+idecal
        idnoeu=jrlno+idecal
        iddl=jrldd+idecal

        nbpar = 3
        do ino = 1, nbterm
            noeud = zk8(idnoeu+ino-1)
            comp = zk8(iddl+ino-1)
            coef = zr(jrlcof+ino-1)
            
            call tbajli(table, nbpar, nompar(2:4), [ibid], [coef],&
                    [cbid], [noeud, comp], 0)
        enddo
    end do

    call jedetr(lisrel//'.RLCO')
    call jedetr(lisrel//'.RLDD')
    call jedetr(lisrel//'.RLNO')
    call jedetr(lisrel//'.RLBE')
    call jedetr(lisrel//'.RLNT')
    call jedetr(lisrel//'.RLPO')
    call jedetr(lisrel//'.RLSU')
    call jedetr(lisrel//'.RLNR')
    call jedetr(lisrel//'.RLTC')
    call jedetr(lisrel//'.RLTV')
    call jedetr(lisrel//'.RLLA')
!
999 continue
    call jedema()
end subroutine
