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

subroutine xcpmod(modmes, modthx, modmex)
!
! person_in_charge: sam.cuvilliez at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/exixfe.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/xcpmo1.h"
#include "asterfort/xcpmo2.h"
!
    character(len=8) :: modmes, modthx, modmex
!
! ----------------------------------------------------------------------
!
! routine xfem : MODI_MODELE_XFEM
!
! --> traitement particulier realise dans le cas ou le mot-cle
!     MODELE_THER est present. Le modele mecanique xfem en sortie
!     d'operateur est cree : 
!
!     1) par copie des objets contenus dans le modele mecanique
!        sain (mot-cle MODELE_IN)
!     2) par copie des objets propres a xfem contenus dans le modele 
!        thermique xfem donne par l'utiilsateur (mot-cle MODELE_THER)
!
! ----------------------------------------------------------------------
!
! in  modmes : nom du modele mecanique sain (mot-cle MODELE_IN)
! in  modthx : nom du modele thermique x-fem (mot-cle MODELE_THER)
! out modmex : nom du modele mecanique x-fem produit par l'operateur
!
! ----------------------------------------------------------------------
!
    integer :: iret,   iret1, iret2, iret3, iret4, iret5
    character(len=8) :: noma1, noma2, valk(4), k8cont
    character(len=19) :: ligr1, ligr2
    character(len=24) :: pheno
    character(len=8), pointer :: lgrf1(:) => null()
    character(len=8), pointer :: lgrf2(:) => null()
    character(len=8), pointer :: p_mod_ther(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! ----------------------------------------------------------------------
! --- verifications prealables
! ----------------------------------------------------------------------
!
!   modmes doit etre un modele sain
    call exixfe(modmes, iret)
    if (iret .eq. 1) call utmess('F', 'XFEM_79', sk=modmes)

!   modmes doit etre un modele mecanique
    call dismoi('PHENOMENE', modmes, 'MODELE', repk=pheno, arret='F')
    if (pheno .ne. 'MECANIQUE') call utmess('F', 'XFEM_80', sk=modmes)
!
!   modthx doit etre un modele xfem
    call exixfe(modthx, iret)
    if (iret .eq. 0) call utmess('F', 'XFEM_81', sk=modthx)
!   modthx doit etre un modele thermique
    call dismoi('PHENOMENE', modthx, 'MODELE', repk=pheno, arret='F')
    if (pheno .ne. 'THERMIQUE') call utmess('F', 'XFEM_82', sk=modthx)
!
!   modmes et modthx doivent avoir ete crees a partir du meme maillage
    ligr1 = modmes//'.MODELE'
    ligr2 = modthx//'.MODELE'
    call jeveuo(ligr1//'.LGRF', 'L', vk8=lgrf1)
    call jeveuo(ligr2//'.LGRF', 'L', vk8=lgrf2)
    noma1 = lgrf1(1)
    noma2 = lgrf2(1)
    if (noma1 .ne. noma2) then
        valk(1) = modmes
        valk(2) = modthx
        valk(3) = noma1
        valk(4) = noma2
        call utmess('F', 'XFEM_83', nk=4, valk=valk)
    endif
!
!   on interdit le contact
    call getvtx(' ', 'CONTACT', iocc=1, scal=k8cont)
    if (k8cont .ne. 'SANS') call utmess('F', 'XFEM_84')
!
!   on interdit les objets associes aux mailles tardives,
!   noeuds tardifs, ou sd voisinage
    call jeexin(ligr1//'.NEMA', iret1)
    call jeexin(ligr1//'.PRNS', iret2)
    call jeexin(ligr1//'.LGNS', iret3)
    call jeexin(ligr1//'.SSSA', iret4)
    call jeexin(ligr1//'.NVGE', iret5)
    iret1 = iret1+iret2+iret3+iret4+iret5
    ASSERT(iret1.eq.0)
    call jeexin(ligr2//'.NEMA', iret1)
    call jeexin(ligr2//'.PRNS', iret2)
    call jeexin(ligr2//'.LGNS', iret3)
    call jeexin(ligr2//'.SSSA', iret4)
    call jeexin(ligr2//'.NVGE', iret5)
    iret1 = iret1+iret2+iret3+iret4+iret5
    ASSERT(iret1.eq.0)
!
! ----------------------------------------------------------------------
!--- construction du modele out (modmex)
! ----------------------------------------------------------------------
!
!   creation de la partie "standard" du modele modmex
    call xcpmo1(modmes, modthx, modmex)
!
!   copie des objets specifiques a x-fem de modthx dans modmex
    call xcpmo2(modthx, modmex)
!
!   ajout objet MODELE_THER dans le modele produit par l'operateur
    call wkvect(modmex//'.MODELE_THER', 'G V K8', 1, vk8=p_mod_ther)
    p_mod_ther(1) = modthx
!
    call jedema()
!
end subroutine
