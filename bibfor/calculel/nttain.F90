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

subroutine nttain(model , mate  , cara_elem, list_load, nume_dof,&
                  solver, time  , epsr     , lonch    , matass  ,&
                  maprec, cnchci, cnresi   , vtemp    , vtempm  ,&
                  vtempp, vec2nd, chlapm   , chlapp   , ci1     ,&
                  ci2   , testi)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/asasve.h"
#include "asterfort/ascova.h"
#include "asterfort/copisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/resoud.h"
#include "asterfort/vetrth.h"
!
! aslint: disable=W1504
!
    character(len=24), intent(in) :: model
    character(len=24), intent(in) :: mate
    character(len=24), intent(in) :: cara_elem
    character(len=19), intent(in) :: list_load
    character(len=24), intent(in) :: nume_dof
    character(len=19), intent(in) :: solver
    character(len=24), intent(in) :: time
    integer :: lonch
    real(kind=8) :: epsr, testi
    character(len=1) :: ci1, ci2
    character(len=19) :: maprec
    character(len=24) :: matass, cnchci, cnresi
    character(len=24) :: vtemp, vtempm, vtempp, vec2nd, chlapm, chlapp
!
! --------------------------------------------------------------------------------------------------
!
! COMMANDE THER_MOBI_NLINE : ITERATIONS
!
! --------------------------------------------------------------------------------------------------
!
!     IN  VTEMP  : CHAMP DE TEMPERATURE A L'INSTANT PRECEDENT
!     VAR VTEMPM : ITERE PRECEDENT DU CHAMP DE TEMPERATURE
!     OUT VTEMPP : ITERE COURANT   DU CHAMP DE TEMPERATURE
!
! --------------------------------------------------------------------------------------------------
!
    complex(kind=8) :: cbid
    integer :: k,  j2nd,  jtempp
    real(kind=8) :: r8bid, testn
    character(len=1) :: typres
    character(len=19) :: chsol
    character(len=24) :: bidon, veresi, varesi, criter
    character(len=24) :: lload_name, lload_info
    integer :: iret
    real(kind=8), pointer :: tempm(:) => null()
    real(kind=8), pointer :: temp(:) => null()
    real(kind=8), pointer :: vare(:) => null()
    cbid = dcmplx(0.d0, 0.d0)
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    varesi = '&&VARESI'
    criter = '&&RESGRA_GCPC'
    typres = 'R'
    chsol  = '&&NTTAIN.SOLUTION'
    bidon  = '&&FOMULT.BIDON'
    veresi = '&&VERESI           .RELR'
!
    ci1 = ' '
    ci2 = ' '
    lload_name = list_load(1:19)//'.LCHA'
    lload_info = list_load(1:19)//'.INFC'
!
! --- RECUPERATION D'ADRESSES
!
    call jeveuo(vec2nd(1:19)//'.VALE', 'L', j2nd)
!
! ======================================================================
!
! --- VECTEURS ELEMENTAIRES DU SEGOND MEMBRE
!
    call vetrth(model, lload_name, lload_info, cara_elem, mate,&
                time, vtemp, vtempm, chlapm, chlapp,&
                veresi)
!
! --- ASSEMBLAGE DU SEGOND MEMBRE
!
    call asasve(veresi, nume_dof, typres, varesi)
    call ascova('D', varesi, bidon, 'INST', r8bid,&
                typres, cnresi)
    call jeveuo(cnresi(1:19)//'.VALE', 'L', vr=vare)
!
! --- RESOLUTION (VTEMPP CONTIENT LE SECOND MEMBRE, CHSOL LA SOLUTION)
!
    call jeveuo(vtempp(1:19)//'.VALE', 'E', jtempp)
    do k = 1, lonch
        zr(jtempp+k-1) = zr(j2nd+k-1) + vare(k)
    end do
!
    call resoud(matass, maprec, solver, cnchci, 0,&
                vtempp, chsol, 'V', [0.d0], [cbid],&
                criter, .true._1, 0, iret)
!
! --- RECOPIE DANS VTEMPP DU CHAMP SOLUTION CHSOL
!
    call copisd('CHAMP_GD', 'V', chsol, vtempp(1:19))
    call jeveuo(vtempm(1:19)//'.VALE', 'E', vr=tempm)
    call jeveuo(vtemp(1:19)//'.VALE', 'E', vr=temp)
    call jeveuo(vtempp(1:19)//'.VALE', 'L', jtempp)
!
! --- EVALUATION DE !!T(I+1)-T(I)!! ET ACTUALISATION DE LA TEMPERATURE
!
    testi = 0.d0
    testn = 0.d0
    do k = 1, lonch
        testi = testi + (zr(jtempp+k-1)-tempm(k))**2
        testn = testn + (zr(jtempp+k-1))**2
        temp(k) = tempm(k)
        tempm(k) = zr(jtempp+k-1)
    end do
    if (testn .gt. 0) testi = testi/testn
!
! --- A-T-ON CONVERGE ?
!
    testi = sqrt(testi)
    if (testi .le. epsr) then
        ci1 = '*'
    else
        ci1 = ' '
    endif
!-----------------------------------------------------------------------
    call jeexin(criter(1:19)//'.CRTI', iret)
    if (iret .ne. 0) then
        call jedetr(criter(1:19)//'.CRTI')
        call jedetr(criter(1:19)//'.CRTR')
        call jedetr(criter(1:19)//'.CRDE')
    endif
    call jedema()
end subroutine
