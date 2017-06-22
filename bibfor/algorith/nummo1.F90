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

subroutine nummo1(nugene, modmec, nbmode, typrof)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/crsmos.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecreo.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/profgene_crsd.h"
!
!
    integer, intent(in) :: nbmode
    character(len=8), intent(in) :: modmec
    character(len=*), intent(in) :: typrof
    character(len=14), intent(in) :: nugene
!
! --------------------------------------------------------------------------------------------------
!
!    BUT: < NUMEROTATION GENERALISEE >
!
!    DETERMINER LA NUMEROTATION GENERALISEE A PARTIR D'UN MODE_MECA
!    OU D'UN MODE_GENE
!
! IN : NUGENE : NOM K14 DU NUME_DDL_GENE
! IN : MODMEC : NOM K8 DU MODE_MECA OU DU MODE_GENE
! IN : NBMODE : NOMBRE DE MODES
! IN : TYPROF : TYPE DE STOCKAGE
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: prof_gene, stomor
    character(len=24) :: lili, orig, prno
    integer :: i_ligr_link, i_ligr_sstr
    integer, pointer :: prgene_orig(:) => null()
    integer, pointer :: prgene_prno(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    prof_gene=nugene//'.NUME'
    stomor=nugene//'.SMOS'
    lili=prof_gene//'.LILI'
    orig=prof_gene//'.ORIG'
    prno=prof_gene//'.PRNO'
!
! - Create PROF_GENE
!
    call profgene_crsd(prof_gene, 'G', nbmode, nb_sstr = 1, nb_link = 1,&
                       model_genez = modmec, gran_namez = 'DEPL_R')
!
! - Set sub_structures
!
    call jenonu(jexnom(lili, '&SOUSSTR'), i_ligr_sstr)
    ASSERT(i_ligr_sstr.eq.1)
    call jeveuo(jexnum(prno, i_ligr_sstr), 'E', vi = prgene_prno)
    call jeveuo(jexnum(orig, i_ligr_sstr), 'E', vi = prgene_orig)
    prgene_prno(1) = 1
    prgene_prno(2) = nbmode
    prgene_orig(1) = 1
!
! - Set links
!
    call jenonu(jexnom(lili, 'LIAISONS'), i_ligr_link)
    call jeveuo(jexnum(orig, i_ligr_link), 'E', vi = prgene_prno)
    call jeveuo(jexnum(orig, i_ligr_link), 'E', vi = prgene_orig)
    prgene_prno(1) = 0
    prgene_orig(1) = 1
!
!     CREATION DU STOCKAGE MORSE :
    call crsmos(stomor, typrof, nbmode)

end subroutine
