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

subroutine cresol(solveu)
    use superv_module, only: asthread_blasset
    implicit none
#include "jeveux.h"
#include "asterc/getexm.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/crsvgc.h"
#include "asterfort/crsvld.h"
#include "asterfort/crsvmf.h"
#include "asterfort/crsvmu.h"
#include "asterfort/crsvpe.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/sdsolv.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=19) :: solveu
! person_in_charge: jacques.pellet at edf.fr
! ----------------------------------------------------------------------
!
!     CREATION D'UNE SD_SOLVEUR PAR LECTURE DU MOT CLE SOLVEUR
!
! IN/JXOUT K19 SOLVEU  : SD_SOLVEUR
!
! ----------------------------------------------------------------------
!
    integer :: zslvk, zslvr, zslvi
    integer :: istop, nsolve, ibid, nprec, islvk, islvr, islvi, n1
    real(kind=8) :: epsmat
    character(len=3) :: mixpre, kellag
    character(len=8) :: kstop, modele, kxfem
    character(len=16) :: method, nomsol
    integer :: eximc
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITS. GLOBALES (CAR MOT-CLES OPTIONNELS)
    nomsol='SOLVEUR'
    nprec=8
    istop=0
    kstop=' '
    epsmat=-1.d0
    mixpre='NON'
    modele = ' '
    kellag='NON'
    kxfem=' '
!
    call getfac(nomsol, nsolve)
    if (nsolve .eq. 0) goto 10
    call getvtx(nomsol, 'METHODE', iocc=1, scal=method, nbret=ibid)
!
! ------------------------------------------------------
! --- LECTURE BLOC COMMUN A TOUS LES SOLVEURS LINEAIRES
! --- CES PARAMETRES NE SONT PAS FORCEMENT UTILISES PAR
! --- TOUS LES OPERATEURS ET TOUS LES SOLVEURS
! ------------------------------------------------------
!
! ----- STOP SINGULIER/NPREC
    eximc=getexm(nomsol,'STOP_SINGULIER')
    if (eximc .eq. 1) then
        call getvtx(nomsol, 'STOP_SINGULIER', iocc=1, scal=kstop, nbret=ibid)
    endif
    eximc=getexm(nomsol,'NPREC')
    if (eximc .eq. 1) then
        call getvis(nomsol, 'NPREC', iocc=1, scal=nprec, nbret=ibid)
        if (kstop .eq. 'OUI') then
            istop = 0
        else if (kstop.eq.'NON') then
            istop = 1
        endif
    endif
!
! ----- FILTRAGE_MATRICE
    eximc=getexm(nomsol,'FILTRAGE_MATRICE')
    if (eximc .eq. 1) then
        call getvr8(nomsol, 'FILTRAGE_MATRICE', iocc=1, scal=epsmat, nbret=ibid)
    endif
!
! ----- MIXER PRECISION
    eximc=getexm(nomsol,'MIXER_PRECISION')
    if (eximc .eq. 1) then
        call getvtx(nomsol, 'MIXER_PRECISION', iocc=1, scal=mixpre, nbret=ibid)
    endif
!
! ------ ELIM_LAGR
    eximc=getexm(nomsol,'ELIM_LAGR')
    if (eximc .eq. 1) then
        call getvtx(nomsol, 'ELIM_LAGR', iocc=1, scal=kellag, nbret=n1)
        if (n1 .eq. 1) then
            if (kellag .ne. 'OUI') kellag='NON'
        else
            kellag='NON'
        endif
    endif
!
! ------ PRE_COND_XFEM
    eximc=getexm(' ','MODELE')
    if (eximc .eq. 1) then
        call getvid(' ', 'MODELE', scal=modele, nbret=n1)
            if (n1 .eq. 1 .and. modele .ne. ' ') then
               call dismoi('PRE_COND_XFEM', modele, 'MODELE', repk=kxfem)
            endif
    endif
!
    zslvk = sdsolv('ZSLVK')
    zslvr = sdsolv('ZSLVR')
    zslvi = sdsolv('ZSLVI')
    call wkvect(solveu//'.SLVK', 'V V K24', zslvk, islvk)
    call wkvect(solveu//'.SLVR', 'V V R', zslvr, islvr)
    call wkvect(solveu//'.SLVI', 'V V I', zslvi, islvi)
!
! ------------------------------------------------------
! --- LECTURE MOT-CLE ET REMPLISSAGE DE LA SD_SOLVEUR PROPRE A CHAQUE
!     SOLVEUR LINEAIRE
! ------------------------------------------------------
!
    if (method .eq. 'MUMPS') then
!     -----------------------------
        call crsvmu(nomsol, solveu, istop, nprec,&
                    epsmat, mixpre, kellag, kxfem)
!
    else if (method.eq.'PETSC') then
!     -----------------------------
        call crsvpe(nomsol, solveu, kellag )
!
    else if (method.eq.'LDLT') then
!     -----------------------------
        call crsvld(nomsol, solveu, istop, nprec,&
                    epsmat, mixpre, kellag, kxfem)
!
    else if (method.eq.'GCPC') then
!     -----------------------------
        call crsvgc(nomsol, solveu, istop, nprec,&
                    epsmat, mixpre, kellag, kxfem)
!
    else if (method.eq.'MULT_FRONT') then
!     -----------------------------
!       do not create threads in blas
        call asthread_blasset(1)
        call crsvmf(nomsol, solveu, istop, nprec,&
                    epsmat, mixpre, kellag, kxfem)
!
    else
        ASSERT(.false.)
    endif
!
 10 continue
!
    call jedema()
end subroutine
