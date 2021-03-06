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

subroutine asexci(masse, momec, amort, nbmode, corfre,&
                  impr, ndir, monoap, muapde, kspect,&
                  kasysp, nbsup, nsupp, knoeu, nopara,&
                  nordr)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/asexc1.h"
#include "asterfort/asexc2.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/typddl.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
    integer :: nbmode, impr, ndir(*), nbsup, nsupp(*), nordr(*)
    real(kind=8) :: amort(*)
    character(len=*) :: masse, kspect, kasysp, knoeu, momec
    character(len=24) :: nopara(*)
    aster_logical :: monoap, muapde, corfre
!     COMMANDE : COMB_SISM_MODAL
!                TRAITEMENT DU MOT-CLE "EXCIT"
!                INTERPOLATION DES SPECTRES
!                CALCUL DES ASYMPTOTES DES SPECTRES
!     ------------------------------------------------------------------
! IN  : MASSE  : MATRICE DE MASSE ASSEMBLEE
! IN  : MOMEC  : MODES MECANIQUES
! IN  : AMORT  : VECTEUR DES AMORTISSEMENTS MODAUX
! IN  : NBMODE : NOMBRE DE MODES
! IN  : CORFRE : = .TRUE.  , CORRECTION FREQUENCE
! IN  : IMPR   : NIVEAU D'IMPRESSION
! OUT : NDIR   : VECTEUR DES DIRECTIONS
! OUT : MONOAP : = .TRUE.  , STRUCTURE MONO-APPUI
!                = .FALSE. , STRUCTURE MULTI-APPUI
! OUT : MUAPDE : = .TRUE.  , STRUCTURE MULTI-APPUI DECORRELE
!                = .FALSE. , STRUCTURE MULTI-APPUI CORRELE
! IN  : KSPECT : NOM DU VECTEUR DES INTERPOLATIONS SPECTRALES
! OUT : MONOAP : = .TRUE.  , STRUCTURE MONO-APPUI
!                = .FALSE. , STRUCTURE MULTI-APPUI
! IN  : KASYSP : NOM DU VECTEUR DES VALEURS ASYMPTOTIQUES DES SPECTRES
! OUT : NBSUP  : SUP DES NOMBRES DE SUPPORTS PAR DIRECTION
! OUT : NSUPP  : NOMBRE DE SUPPORTS PAR DIRECTION
! IN  : KNOEU  : NOM DU VECTEUR DES NOMS DES SUPPORTS
!     ------------------------------------------------------------------
    integer :: ier, im1, im2, ioc, nm, nn, ng, nbocc, jasy, neq, jddl1
    integer :: nba, nbbloq, nbl, nbliai, jspe, noc
    character(len=5) :: motfac
    character(len=8) :: k8b, noma
    character(len=14) :: nume
    real(kind=8), pointer :: dir_spectre(:) => null()
    real(kind=8), pointer :: ech_spectre(:) => null()
    integer, pointer :: nat_spectre(:) => null()
    character(len=8), pointer :: nom_noeud(:) => null()
    character(len=8), pointer :: nom_spectre(:) => null()
!     ------------------------------------------------------------------
!
    call jemarq()
    ier = 0
    monoap = .false.
    muapde = .true.
!
!     --- EST-ON EN MONO-APPUI OU MULTI-APPUI ? ---
    im1 = 0
    im2 = 0
    call getvtx(' ', 'MONO_APPUI', scal=k8b, nbret=nm)
    if (nm .ne. 0) then
        im1 = im1 + 1
        if (k8b(1:3) .eq. 'OUI') monoap = .true.
    endif
!
    call getvtx(' ', 'MULTI_APPUI', scal=k8b, nbret=nm)
    if (nm .ne. 0) then
        im2 = im2 + 1
        if (k8b(1:7) .eq. 'CORRELE') muapde = .false.
    endif
!
!     --- VERIFICATION DES APPUIS ---
    motfac = 'EXCIT'
    call getfac(motfac, nbocc)
    do ioc = 1, nbocc
!
        call getvtx(motfac, 'NOEUD', iocc=ioc, nbval=0, nbret=nn)
        if (nn .ne. 0 .and. monoap) then
            ier = ier + 1
            call utmess('E', 'SEISME_8')
        endif
!
        call getvtx(motfac, 'GROUP_NO', iocc=ioc, nbval=0, nbret=ng)
        if (ng .ne. 0 .and. monoap) then
            ier = ier + 1
            call utmess('E', 'SEISME_8')
        endif
    end do
!
    if (ier .ne. 0) then
        call utmess('F', 'SEISME_6')
    endif
    if (im1 .ne. 0 .and. im2 .ne. 0) then
        call utmess('F', 'SEISME_8')
    endif
!
!
! SI DECORRELE LA SOMME INTERGROUPE DOIT ETRE QUADRATIQUE
!
    if ((.not.monoap) .and. (.not.muapde)) then
        call getfac('GROUP_APPUI', noc)
        if (noc .ne. 0) then
            call utmess('F', 'SEISME_29')
        endif
    endif
!
    if (monoap) then
        nbsup = 1
        call wkvect(kspect, 'V V R', nbmode*3, jspe)
        call wkvect(kasysp, 'V V R', 3, jasy)
        call asexc1(motfac, nbocc, nbmode, momec, amort,&
                    corfre, ndir, zr(jspe), zr(jasy), nopara,&
                    nordr)
    else
        call dismoi('NOM_NUME_DDL', masse, 'MATR_ASSE', repk=nume)
        call dismoi('NOM_MAILLA', masse, 'MATR_ASSE', repk=noma)
        call dismoi('NB_EQUA', masse, 'MATR_ASSE', repi=neq)
        call wkvect('&&ASEXCI.POSITION.DDL1', 'V V I', neq, jddl1)
        call typddl('BLOQ', nume, neq, zi(jddl1), nba,&
                    nbbloq, nbl, nbliai)
        if (nbbloq .eq. 0) then
            call utmess('F', 'SEISME_34')
        endif
        AS_ALLOCATE(vk8=nom_noeud, size=3*nbbloq)
        AS_ALLOCATE(vk8=nom_spectre, size=3*nbbloq)
        AS_ALLOCATE(vr=dir_spectre, size=3*nbbloq)
        AS_ALLOCATE(vr=ech_spectre, size=3*nbbloq)
        AS_ALLOCATE(vi=nat_spectre, size=3*nbbloq)
        call asexc2(motfac, nbocc, nbmode, momec, amort,&
                    corfre, noma, ndir, nom_noeud, nom_spectre,&
                    dir_spectre, ech_spectre, nat_spectre, nbsup, nsupp,&
                    knoeu, kspect, kasysp, nopara, nordr)
        call jedetr('&&ASEXCI.POSITION.DDL1')
        AS_DEALLOCATE(vk8=nom_noeud)
        AS_DEALLOCATE(vk8=nom_spectre)
        AS_DEALLOCATE(vr=dir_spectre)
        AS_DEALLOCATE(vr=ech_spectre)
        AS_DEALLOCATE(vi=nat_spectre)
    endif
!
    call jedema()
end subroutine
