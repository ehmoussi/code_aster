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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine vefnme(optionz, modelz    , mate , cara_elem,&
                  compor , partps    , nh   , ligrelz  ,&
                  varcz  , sigmz     , strxz,&
                  dispz  , disp_incrz,&
                  base   , vect_elemz)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/corich.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/exixfe.h"
#include "asterfort/gcnco2.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/mecact.h"
#include "asterfort/mecara.h"
#include "asterfort/reajre.h"
#include "asterfort/exisd.h"
#include "asterfort/xajcin.h"
#include "asterfort/maveElemCreate.h"
!
character(len=*), intent(in) :: optionz, modelz
character(len=24), intent(in) :: cara_elem, mate
character(len=19), intent(in) :: compor
real(kind=8), intent(in) :: partps(*)
integer, intent(in) :: nh
character(len=*), intent(in) :: ligrelz
character(len=*), intent(in) :: sigmz, varcz, strxz, dispz, disp_incrz
character(len=1), intent(in) :: base
character(len=*), intent(in) :: vect_elemz
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Option: FORC_NODA
!         FONL_NOEU
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : NOM DU MODELE (NECESSAIRE SI SIGMA EST UNE CARTE)
! IN  SIGMA  : NOM DU CHAM_ELEM (OU DE LA CARTE) DE CONTRAINTES
! IN  CARA   : NOM DU CARA_ELEM
! IN  DEPMOI : NOM DU CHAM_NO DE DEPLACEMENTS PRECEDENTS
! IN  DEPDEL : NOM DU CHAM_NO D'INCREMENT DEPLACEMENTS
! IN  MATCOD : NOM DU MATERIAU CODE
! IN  COMPOR : NOM DE LA CARTE DE COMPORTEMENT
! IN  NH     : NUMERO D'HARMONIQUE DE FOURIER
! IN  PARTPS : INSTANT PRECEDENT ET ACTUEL
! IN  CARCRI : CARTE DES CRITERES ET DE THETA
! IN  CHVARC : NOM DU CHAMP DE VARIABLE DE COMMANDE
! IN  LIGREZ : (SOUS-)LIGREL DE MODELE POUR CALCUL REDUIT
!                  SI ' ', ON PREND LE LIGREL DU MODELE
! OUT VECELZ : VECT_ELEM RESULTAT.
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: mxchin  = 35, nbout = 1
    character(len=8) :: lpaout(nbout), lpain(mxchin)
    character(len=19) :: lchout(nbout), lchin(mxchin)
    aster_logical :: l_xfem
    character(len=8) :: mesh, newnom, model
    character(len=16) :: option
    character(len=19) :: vect_elem, resu_elem
    character(len=19) :: chharm, tpsmoi, tpsplu, ligrel_local, ligrel
    character(len=19) :: chgeom, chcara(18)
    integer :: ibid, iret, nbin
    real(kind=8) :: instm, instp
    character(len=19) :: sigm, varc, strx, disp, disp_incr
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    lpaout    = ' '
    lpain     = ' '
    lchout    = ' '
    lchin     = ' '
    model     = modelz
    sigm      = sigmz
    varc      = varcz
    strx      = strxz
    disp      = dispz
    disp_incr = disp_incrz
    ligrel    = ligrelz
    newnom    = '.0000000'
    vect_elem = vect_elemz
    resu_elem = vect_elem(1:8)//'.0000000'
    call exixfe(model, iret)
    l_xfem = (iret .eq. 1)
    chharm    = '&&VEFNME.NUME_HARM'
    tpsmoi    = '&&VEFNME.CH_INSTAM'
    tpsplu    = '&&VEFNME.CH_INSTAP'
    option    = optionz
    if (ligrel .eq. ' ') then
        ligrel_local = model(1:8)//'.MODELE'
    else
        ligrel_local = ligrel
    endif
!
! - Geometry field
!
    if (disp .ne. ' ') then
        call dismoi('NOM_MAILLA', disp, 'CHAM_NO', repk=mesh)
    else if (sigm.ne.' ') then
        call dismoi('NOM_MAILLA', sigm, 'CHAM_ELEM', repk=mesh)
    else
        ASSERT(ASTER_FALSE)
    endif
    chgeom = mesh(1:8)//'.COORDO'
!
! - Field for structural elements
!
    call mecara(cara_elem(1:8), chcara)
!
! - Field for Fourier mode
!
    call mecact('V', chharm, 'MAILLA', mesh, 'HARMON',&
                ncmp=1, nomcmp='NH', si=nh)
!
! - Field for time
!
    instm = partps(1)
    instp = partps(2)
    call mecact('V', tpsmoi, 'MAILLA', mesh, 'INST_R',&
                ncmp=1, nomcmp='INST', sr=instm)
    call mecact('V', tpsplu, 'MAILLA', mesh, 'INST_R',&
                ncmp=1, nomcmp='INST', sr=instp)
!
! - Suppress old vect_elem result
!
    call detrsd('VECT_ELEM', vect_elem)
    call maveElemCreate(base, 'MECA', vect_elem, model, ' ', cara_elem)
!
! - Input fields
!
    lpain(1) = 'PGEOMER'
    lchin(1) = chgeom
    lpain(2) = 'PMATERC'
    lchin(2) = mate(1:19)
    lpain(3) = 'PCAGNPO'
    lchin(3) = chcara(6)
    lpain(4) = 'PCAORIE'
    lchin(4) = chcara(1)
    lpain(5) = 'PCOMPOR'
    lchin(5) = compor
    lpain(6) = 'PCONTMR'
    lchin(6) = sigm
    lpain(7) = 'PDEPLMR'
    lchin(7) = disp
    lpain(8) = 'PDEPLPR'
    lchin(8) = disp_incr
    lpain(9) = 'PCAARPO'
    lchin(9) = chcara(9)
    lpain(10) = 'PCADISK'
    lchin(10) = chcara(2)
    lpain(11) = 'PCACOQU'
    lchin(11) = chcara(7)
    lpain(12) = 'PHARMON'
    lchin(12) = chharm
    lpain(13) = 'PCAMASS'
    lchin(13) = chcara(12)
    lpain(14) = 'PINSTMR'
    lchin(14) = tpsmoi
    lpain(15) = 'PINSTPR'
    lchin(15) = tpsplu
    lpain(16) = 'PVARCPR'
    lchin(16) = varc
    lpain(17) = 'PCAGEPO'
    lchin(17) = chcara(5)
    lpain(18) = 'PNBSP_I'
    lchin(18) = chcara(16)
    lpain(19) = 'PFIBRES'
    lchin(19) = chcara(17)
    lpain(20) = 'PCINFDI'
    lchin(20) = chcara(15)
    lpain(21) = 'PSTRXMR'
    lchin(21) = strx
    nbin = 21
!
! - XFEM fields
!
    if (l_xfem) then
        call xajcin(model, option, mxchin, lchin, lpain, nbin)
    endif
!
! - Output field
!
    lpaout(1) = 'PVECTUR'
    call gcnco2(newnom)
    resu_elem(10:16) = newnom(2:8)
    call corich('E', resu_elem, -1, ibid)
    lchout(1) = resu_elem
!
! - Computation
!
    call calcul('S'  , option, ligrel_local, nbin, lchin,&
                lpain, nbout , lchout, lpaout, base,&
                'OUI')
!
! - Copying output field
!
    call reajre(vect_elem, resu_elem, base)
!
! - Clean
!
    call detrsd('CHAMP_GD', chharm)
    call detrsd('CHAMP_GD', tpsmoi)
    call detrsd('CHAMP_GD', tpsplu)
!
    call jedema()
end subroutine
