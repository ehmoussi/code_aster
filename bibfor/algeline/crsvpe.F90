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

subroutine crsvpe(motfac, solveu,  kellag )
    implicit none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/gcncon.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
    character(len=3) :: kellag
    character(len=16) :: motfac
    character(len=19) :: solveu
!  BUT : REMPLISSAGE SD_SOLVEUR PETSC
!
! IN K19 SOLVEU  : NOM DU SOLVEUR DONNE EN ENTREE
! OUT    SOLVEU  : LE SOLVEUR EST CREE ET INSTANCIE
! IN  K3 KELLAG  : ELIM_LAGR
! ----------------------------------------------------------
!
    integer :: ibid, niremp, nmaxit, reacpr, pcpiv
    real(kind=8) :: fillin, epsmax, resipc, blreps
    character(len=8) :: kacmum
    character(len=24) :: kalgo, kprec, renum
    character(len=19) :: solvbd
    character(len=24) :: usersm
    character(len=24), pointer :: slvk(:) => null()
    integer, pointer :: slvi(:) => null()
    real(kind=8), pointer :: slvr(:) => null()
!
!------------------------------------------------------------------
    call jemarq()
!
! --- LECTURES PARAMETRES DEDIES AU SOLVEUR
!     PARAMETRES FORCEMENT PRESENTS
    call getvtx(motfac, 'ALGORITHME', iocc=1, scal=kalgo, nbret=ibid)
    ASSERT(ibid.eq.1)
    call getvtx(motfac, 'PRE_COND', iocc=1, scal=kprec, nbret=ibid)
    ASSERT(ibid.eq.1)
    call getvtx(motfac, 'RENUM', iocc=1, scal=renum, nbret=ibid)
    ASSERT(ibid.eq.1)
    call getvr8(motfac, 'RESI_RELA', iocc=1, scal=epsmax, nbret=ibid)
    ASSERT(ibid.eq.1)
    call getvis(motfac, 'NMAX_ITER', iocc=1, scal=nmaxit, nbret=ibid)
    ASSERT(ibid.eq.1)
    call getvr8(motfac, 'RESI_RELA_PC', iocc=1, scal=resipc, nbret=ibid)
    ASSERT(ibid.eq.1)
!
!
!     INITIALISATION DES PARAMETRES OPTIONNELS
    niremp = 0
    fillin = 1.d0
    reacpr = 0
    pcpiv = -9999
    solvbd = ' '
    usersm = 'XXXX'
    blreps = 0.d0
    kacmum = 'XXXX'
!
    select case (kprec)
    case('LDLT_INC')
        call getvis(motfac, 'NIVE_REMPLISSAGE', iocc=1, scal=niremp, nbret=ibid)
        ASSERT(ibid.eq.1)
        call getvr8(motfac, 'REMPLISSAGE', iocc=1, scal=fillin, nbret=ibid)
        ASSERT(ibid.eq.1)

!   PARAMETRES OPTIONNELS LIES AU PRECONDITIONNEUR LDLT_SP/LDLT_DP
    case ('LDLT_SP','LDLT_DP') 
        call getvis(motfac, 'REAC_PRECOND', iocc=1, scal=reacpr, nbret=ibid)
        ASSERT(ibid.eq.1)
        call getvis(motfac, 'PCENT_PIVOT', iocc=1, scal=pcpiv, nbret=ibid)
        ASSERT(ibid.eq.1)
        call getvtx(motfac, 'GESTION_MEMOIRE', iocc=1, scal=usersm, nbret=ibid)
        ASSERT(ibid.eq.1)
        
!       NOM DE SD SOLVEUR BIDON QUI SERA PASSEE A MUMPS
!       POUR LE PRECONDITIONNEMENT
        call gcncon('.', solvbd)
! 
        if (nmaxit==0) nmaxit=100
        if (( kprec.eq.'LDLT_SP' ).or.( kprec .eq. 'LDLT_DP')) then
            call getvr8(motfac, 'LOW_RANK_SEUIL', iocc=1, scal=blreps, nbret=ibid)
            ASSERT(ibid.eq.1)
            if ( abs(blreps) < r8prem() ) then 
               kacmum = 'FR+'
            else 
               kacmum='LR+'
            endif 
        endif
!

!   PARAMETRES OPTIONNELS LIES AU MULTIGRILLE ALGEBRIQUE ML
    case ('ML') 

!   PARAMETRES OPTIONNELS LIES AU MULTIGRILLE ALGEBRIQUE BOOMERAMG
    case ('BOOMER')
!
!   PARAMETRES OPTIONNELS LIES AU MULTIGRILLE ALGEBRIQUE BOOMERAMG
    case ('GAMG')
!   PARAMETRES OPTIONNELS LIES AU PRECONDITIONNEUR LAGRANGIEN AUGMENTE
    case ('BLOC_LAGR')

!   PAS DE PARAMETRES POUR LES AUTRES PRECONDITIONNEURS
    case( 'JACOBI', 'SOR', 'SANS','FIELDSPLIT') 
!     RIEN DE PARTICULIER...
!
    case default
        ASSERT(.false.)
    end select
!
! --- ON REMPLIT LA SD_SOLVEUR
    call jeveuo(solveu//'.SLVK', 'E', vk24=slvk)
    call jeveuo(solveu//'.SLVR', 'E', vr=slvr)
    call jeveuo(solveu//'.SLVI', 'E', vi=slvi)
!
    slvk(1) = 'PETSC'
    slvk(2) = kprec
    slvk(3) = solvbd
    slvk(4) = renum
    slvk(5) = kacmum
    slvk(6) = kalgo
    slvk(7) = 'XXXX'
    slvk(8) = 'XXXX'
    slvk(9) = usersm
    slvk(10)= 'XXXX'
    slvk(11)= 'XXXX'
    slvk(12)= 'XXXX'
    slvk(13)= kellag
    slvk(14)= 'XXXX'
!
!
!     POUR NEWTON_KRYLOV LE RESI_RELA VARIE A CHAQUE
!     ITERATION DE NEWTON, CEPENDANT LE RESI_RELA DONNE
!     PAR L'UTILISATEUR TOUT DE MEME NECESSAIRE
!     C'EST POURQUOI ON EN FAIT UNE COPIE EN POSITION 1
    slvr(1) = epsmax
    slvr(2) = epsmax
    slvr(3) = fillin
    slvr(4) = blreps
    slvr(5) = resipc
!
    slvi(1) = -9999
    slvi(2) = nmaxit
    slvi(3) = -9999
    slvi(4) = niremp
    slvi(5) = 0
    slvi(6) = reacpr
    slvi(7) = pcpiv
    slvi(8) = 0
!
!
! FIN ------------------------------------------------------
    call jedema()
end subroutine
